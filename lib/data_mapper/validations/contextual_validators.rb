# -*- encoding: utf-8 -*-

require 'data_mapper/validations/context'
require 'data_mapper/validations/rule_set'

module DataMapper
  module Validations
    class ContextualValidators
      include Enumerable

      # @api private
      attr_reader :contexts

      def initialize(model = nil)
        @model    = model
        @contexts = Hash.new do |h, context_name|
          h[context_name] = RuleSet.new(context_name)
        end
      end

      # Delegate #validate to RuleSet
      # 
      # @api public
      def validate(context_name, resource)
        context(context_name).validate(resource)
      end

      # @api public
      def each
        contexts.each { |context| yield context }
      end

      # @api public
      def empty?
        contexts.empty?
      end

      # Return an array of validators for a named context
      #
      # @param  [String]
      #   Context name for which to return validators
      # @return [Array(Validator)]
      #   An array of validators bound to the given context
      # 
      # @api public
      def context(name)
        contexts[name]
      end

      # Clear all named context validators off of the resource
      #
      # @api public
      def clear!
        contexts.clear
      end

      # Create a new validator of the given klazz and push it onto the
      # requested context for each of the attribute_names in +attribute_names+
      # 
      # @param [DataMapper::Validations::GenericValidator] validator_class
      #    Validator class, example: DataMapper::Validations::LengthValidator
      #
      # @param [Array<Symbol>] attribute_names
      #    Attribute names given to validation macro, example:
      #    [:first_name, :last_name] in validates_presence_of :first_name, :last_name
      # 
      # @param [Hash] options
      #    Options supplied to validation macro, example:
      #    {:context=>:default, :maximum=>50, :allow_nil=>true, :message=>nil}
      # 
      # @option [Symbol] :context
      #   the context in which the new validator should be run
      # @option [Boolean] :allow_nil
      #   whether or not the new validator should allow nil values
      # @option [Boolean] :message
      #   the error message the new validator will provide on validation failure
      # 
      # @return [ContextualValidators]
      #   This method is a command, thus returns the receiver
      def add(validator_class, *attribute_names, &block)
        options  = attribute_names.last.kind_of?(Hash) ? attribute_names.pop.dup : {}
        contexts = extract_contexts(options)

        attribute_names.each do |attribute_name|
          validators = validator_class.validators_for(attribute_name, options, &block)

          contexts.each do |context|
            validators.each { |validator| self.context(context) << validator }

            # TODO: eliminate ModelExtensions#create_context_instance_methods,
            #   then eliminate the @model ivar entirely
            # In the meantime, update this method to return the context names
            #   to which validators were added, then override the Model methods
            #   in Macros to add these context shortcuts (as a deprecated shim)
            ContextualValidators.create_context_instance_methods(@model, context) if @model
          end
        end

        self
      end

      def inherited(descendant_validators)
        contexts.each do |context, validators|
          validators.each do |validator|
            # TODO: add a new API for adding an initialized Validator
            # (as opposed to a Validator descendant class). Adding members
            # directly to the context's OrderedSet makes it difficult to support
            # indexing validators by validated attribute name.
            descendant_validators.context(context) << validator.dup
          end
        end
      end

      # Returns the current validation context on the stack if valid for this model,
      # nil if no contexts are defined for the model (and no contexts are on
      # the validation stack), or :default if the current context is invalid for
      # this model or no contexts have been defined for this model and
      # no context is on the stack.
      #
      # @return [Symbol]
      #   the current validation context from the stack (if valid for this model),
      #   nil if no context is on the stack and no contexts are defined for this model,
      #   or :default if the context on the stack is invalid for this model or
      #   no context is on the stack and this model has at least one validation context
      # 
      # @api private
      # 
      # TODO: simplify the semantics of #current_context, #validate
      def current_context
        context = Validations::Context.current
        valid_context?(context) ? context : :default
      end

      # Test if the context is valid for the model
      #
      # @param [Symbol] context
      #   the context to test
      #
      # @return [Boolean]
      #   true if the context is valid for the model
      #
      # @api private
      # 
      # TODO: investigate removing the `contexts.empty?` test here.
      def valid_context?(context)
        contexts.empty? || contexts.include?(context)
      end

      # Assert that the given context is valid for this model
      #
      # @param [Symbol] context
      #   the context to test
      #
      # @raise [InvalidContextError]
      #   raised if the context is not valid for this model
      #
      # @api private
      # 
      # TODO: is this method actually needed?
      def assert_valid(context)
        unless valid_context?(context)
          raise InvalidContextError, "#{context} is an invalid context, known contexts are #{contexts.keys.inspect}"
        end
      end

    private

      # Allow :context to be aliased to :group, :on, & :when
      # 
      # @param [Hash] options
      #   the options from which +context+ is to be extracted
      # 
      # @return [Array(Symbol)]
      #   the context(s) from +options+
      # 
      # @api private
      def extract_contexts(options)
        context = [
          options.delete(:context),
          options.delete(:group),
          options.delete(:when),
          options.delete(:on)
        ].compact.first

        Array(context || :default)
      end

      # Given a new context create an instance method of
      # valid_for_<context>? which simply calls validate(context)
      # if it does not already exist
      #
      # @api private
      def self.create_context_instance_methods(model, context)
        # TODO: deprecate `valid_for_#{context}?`
        # what's wrong with requiring the caller to pass the context as an arg?
        #   eg, `validate(:context)`
        # these methods *are* handy for symbol-based callbacks,
        #   eg. `:if => :valid_for_context?`
        # but they're so trivial to add where needed that it's
        # overkill to do this for all contexts on all validated objects.
        context = context.to_sym

        name = "valid_for_#{context}?"
        present = model.respond_to?(:resource_method_defined) ? model.resource_method_defined?(name) : model.instance_methods.include?(name)
        unless present
          model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{name}                         # def valid_for_signup?
              validate(#{context.inspect})      #   validate(:signup)
            end                                 # end
          RUBY
        end
      end

    end # class ContextualValidators
  end # module Validations
end # module DataMapper
