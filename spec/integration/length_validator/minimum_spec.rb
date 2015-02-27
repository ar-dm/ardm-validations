require 'spec_helper'
require 'integration/length_validator/spec_helper'

RSpec.shared_examples_for "entity with a name shorter than 2 characters" do
  it "has a meaninful error message with length restrictions mentioned" do
    expect(@model.errors.on(:name)).to eq([ 'Name must be at least 2 characters long' ])
  end
end

describe 'DataMapper::Validations::Fixtures::Mittelschnauzer' do
  before :all do
    DataMapper::Validations::Fixtures::Mittelschnauzer.auto_migrate!

    @model = DataMapper::Validations::Fixtures::Mittelschnauzer.valid_instance
  end

  include_examples "valid model"

  describe "with a 13 characters long name" do
    include_examples "valid model"
  end

  describe "with a single character name" do
    before :all do
      @model.name = "R"
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "entity with a name shorter than 2 characters"
  end

  describe "with blank name" do
    before :all do
      @model.name = ""
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "entity with a name shorter than 2 characters"
  end

  describe "persisted, with a single character owner" do
    before :all do
      @model.save
      @model.owner = 'a'
      @model.valid?
    end

    include_examples "invalid model"
  end
end
