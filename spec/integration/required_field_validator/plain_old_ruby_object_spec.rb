require 'spec_helper'
require 'integration/required_field_validator/spec_helper'

describe 'required_field_validator/plain_old_ruby_object_spec' do

  describe "A plain old Ruby object (not a DM resource)" do
    before do
      class PlainClass
        extend DataMapper::Validations::ClassMethods
        include DataMapper::Validations
        attr_accessor :accessor
        validates_presence_of :here, :empty, :nil, :accessor
        def here;  "here" end
        def empty; ""     end
        def nil;   nil    end
      end

      @pc = PlainClass.new
    end

    it "should fail validation with empty, nil, or blank fields" do
      expect(@pc).not_to be_valid
      expect(@pc.errors.on(:empty)).to    eq([ 'Empty must not be blank' ])
      expect(@pc.errors.on(:nil)).to      eq([ 'Nil must not be blank' ])
      expect(@pc.errors.on(:accessor)).to eq([ 'Accessor must not be blank' ])
    end

    it "giving accessor a value should remove validation error" do
      @pc.accessor = "full"
      @pc.valid?
      expect(@pc.errors.on(:accessor)).to be_nil
    end
  end

end
