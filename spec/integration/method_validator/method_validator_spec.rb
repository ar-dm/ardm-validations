require 'spec_helper'
require 'integration/method_validator/spec_helper'

RSpec.shared_examples_for "a good fit for DSLs" do
  it "is a good fit for DSLs" do
    expect(@model).to be_valid_for_implementing_a_dsl
  end

  it "is totally fine for DSLs" do
    expect(@model.ensure_appropriate_for_dsls).to be(true)
  end
end

RSpec.shared_examples_for "a poor candidate for DSLs" do
  it "is a poor candidate for DSLs" do
    expect(@model).not_to be_valid_for_implementing_a_dsl
  end

  it "is unappropriate for DSLs" do
    expect(@model.ensure_appropriate_for_dsls.first).to be(false)
  end

  it "has a (more or less) meaningful error message" do
    expect(@model.errors.on(:ensure_appropriate_for_dsls)).to eq([ 'may not be so good for domain specific languages' ])
  end
end


RSpec.shared_examples_for "a good fit for game engine core" do
  it "is a good fit for game engine core" do
    expect(@model).to be_valid_for_implementing_a_game_engine_core
  end

  it "is appropriate for system programming" do
    expect(@model.ensure_appropriate_for_system_programming).to be(true)
  end
end

RSpec.shared_examples_for "a poor candidate for game engine core" do
  it "is a poor candidate for game engine core" do
    expect(@model).not_to be_valid_for_implementing_a_game_engine_core
  end
end



RSpec.shared_examples_for "a good fit for kernel hacking" do
  it "is a good fit for kernel hacking" do
    expect(@model).to be_valid_for_hacking_on_the_kernel
  end

  it "is appropriate for system programming" do
    expect(@model.ensure_appropriate_for_system_programming).to be(true)
  end
end


RSpec.shared_examples_for "a poor candidate for kernel hacking" do
  it "is not a good fit for kernel hacking" do
    expect(@model).not_to be_valid_for_hacking_on_the_kernel
  end
end

#
# Note that ProgrammingLanguage is not a DM resource,
# it is a plain old Ruby object (PORO), or simply put,
# just a "regular" Ruby class with a bunch of accessors.
#
# And yes, assumptions below are full of bullshit and
# author is a moron, and your favourite programming
# language is good for EVARYTHIN'!
#
#Please see spec_helper.rb next to this file
#

describe "C" do
  before :all do
    @model = ::DataMapper::Validations::Fixtures::ProgrammingLanguage.new(:name                                     => "C",
                                                                       :allows_system_calls                      => true,
                                                                       :allows_manual_memory_management          => true,
                                                                       :approved_by_linus                        => true,
                                                                       :compiler_excels_at_utilizing_cpu_cache   => true,
                                                                       :is_very_high_level                       => false,
                                                                       :does_not_require_explicit_return_keyword => false,
                                                                       :allows_operator_overload                 => false,
                                                                       :allows_optional_parentheses              => false
                                                                       )
  end

  include_examples "a good fit for kernel hacking"

  include_examples "a good fit for game engine core"

  include_examples "a poor candidate for DSLs"
end



describe "C++" do
  before :all do
    @model = ::DataMapper::Validations::Fixtures::ProgrammingLanguage.new(:name                                     => "C++",
                                                                       :allows_system_calls                      => true,
                                                                       :allows_manual_memory_management          => true,
                                                                       :approved_by_linus                        => false,
                                                                       :compiler_excels_at_utilizing_cpu_cache   => true,
                                                                       :is_very_high_level                       => false,
                                                                       :does_not_require_explicit_return_keyword => false,
                                                                       :allows_operator_overload                 => true,
                                                                       :allows_optional_parentheses              => false
                                                                       )
  end

  include_examples "a poor candidate for kernel hacking"

  include_examples "a good fit for game engine core"

  include_examples "a poor candidate for DSLs"

  it "is not approved by Linus" do
    @model.valid?(:hacking_on_the_kernel)
    expect(@model.errors.on(:ensure_approved_by_linus_himself)).not_to be_empty
  end
end


describe "Ruby" do
  before :all do
    @model = ::DataMapper::Validations::Fixtures::ProgrammingLanguage.new(:name                                     => "Ruby",
                                                                       # well, C extensions do not really count
                                                                       :allows_system_calls                      => false,
                                                                       :allows_manual_memory_management          => false,
                                                                       :approved_by_linus                        => false,
                                                                       :compiler_excels_at_utilizing_cpu_cache   => false,
                                                                       :is_very_high_level                       => true,
                                                                       :does_not_require_explicit_return_keyword => true,
                                                                       :allows_operator_overload                 => true,
                                                                       :allows_optional_parentheses              => true
                                                                       )
  end

  include_examples "a good fit for DSLs"

  include_examples "a poor candidate for kernel hacking"

  include_examples "a poor candidate for game engine core"

  it "has a (more or less) meaningful error message" do
    @model.valid?(:doing_system_programming)
    expect(@model.errors.on(:ensure_appropriate_for_system_programming)).to eq([ 'try something that is closer to the metal' ])
  end
end


describe "Scala" do
  before :all do
    @model = ::DataMapper::Validations::Fixtures::ProgrammingLanguage.new(:name                                     => "Scala",
                                                                       :allows_system_calls                      => false,
                                                                       :allows_manual_memory_management          => false,
                                                                       :approved_by_linus                        => false,
                                                                       :compiler_excels_at_utilizing_cpu_cache   => false,
                                                                       :is_very_high_level                       => true,
                                                                       :does_not_require_explicit_return_keyword => true,
                                                                       :allows_operator_overload                 => true,
                                                                       :allows_optional_parentheses              => true
                                                                       )
  end

  include_examples "a good fit for DSLs"

  include_examples "a poor candidate for kernel hacking"

  include_examples "a poor candidate for game engine core"

  it "has a (more or less) meaningful error message" do
    @model.valid?(:doing_system_programming)
    expect(@model.errors.on(:ensure_appropriate_for_system_programming)).to eq([ 'try something that is closer to the metal' ])
  end
end



describe "Haskell" do
  before :all do
    @model = ::DataMapper::Validations::Fixtures::ProgrammingLanguage.new(:name                                     => "Haskell",
                                                                       :allows_system_calls                      => false,
                                                                       :allows_manual_memory_management          => false,
                                                                       :approved_by_linus                        => false,
                                                                       :compiler_excels_at_utilizing_cpu_cache   => true,
                                                                       :is_very_high_level                       => true,
                                                                       :does_not_require_explicit_return_keyword => true,
                                                                       # operators are not different from any other function
                                                                       :allows_operator_overload                 => true,
                                                                       # or, allows explicit parentheses? who cares, we
                                                                       # are just trying to come up with a relatively
                                                                       # non-stupid spec example
                                                                       :allows_optional_parentheses              => true
                                                                       )
  end

  include_examples "a good fit for DSLs"

  include_examples "a poor candidate for kernel hacking"

  include_examples "a poor candidate for game engine core"

  it "has a (more or less) meaningful error message" do
    @model.valid?(:doing_system_programming)
    expect(@model.errors.on(:ensure_appropriate_for_system_programming)).to eq([ 'try something that is closer to the metal' ])
  end
end


describe 'DataMapper::Validations::Fixtures::Event' do
  before :all do
    DataMapper::Validations::Fixtures::Event.auto_migrate!

    @model = DataMapper::Validations::Fixtures::Event.new(:name => "Fools day 2009")
  end

  describe "with start time before end time" do
    before :all do
      @model.starts_at = DateTime.new(2009, 4, 1, 00, 00, 01)
      @model.ends_at   = DateTime.new(2009, 4, 1, 23, 59, 59)
    end

    include_examples "valid model"
  end

  describe "with start time after end time" do
    before :all do
      @model.starts_at = DateTime.new(2009, 4, 1, 23, 59, 59)
      @model.ends_at   = DateTime.new(2009, 4, 1, 00, 00, 01)
    end

    include_examples "invalid model"

    it "uses custom error message for property starts_at" do
      expect(@model.errors.on(:starts_at)).to eq([ 'Start time cannot be after end time' ])
    end
  end
end
