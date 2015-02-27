require 'spec_helper'
require 'integration/numeric_validator/spec_helper'

describe 'DataMapper::Validations::Fixtures::LerneanHydra' do
  before :all do
    DataMapper::Validations::Fixtures::LerneanHydra.auto_migrate!
  end

  describe "with valid set of attributes" do
    before :all do
      @model = DataMapper::Validations::Fixtures::LerneanHydra.valid_instance
      @model.valid?
    end

    include_examples "valid model"
  end


  describe "with 9 heads" do
    before :all do
      @model = DataMapper::Validations::Fixtures::LerneanHydra.valid_instance(:head_count => 9)
      @model.valid?
    end

    include_examples "valid model"
  end


  describe "with only 3 heads" do
    before :all do
      @model = DataMapper::Validations::Fixtures::LerneanHydra.valid_instance(:head_count => 3)
      @model.valid?
    end

    include_examples "invalid model"

    it "has a meaningful error message" do
      expect(@model.errors.on(:head_count)).to eq([ 'Lernean hydra is said to have exactly 9 heads' ])
    end
  end
end
