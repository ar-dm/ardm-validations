require 'spec_helper'
require 'integration/automatic_validation/spec_helper'

describe "A model with a Boolean property" do
  before :each do
    @model = HasNullableBoolean.new(:id => 1)
  end

  describe "assigned a true" do
    before :each do
      @model.bool = true
    end

    include_examples "valid model"
  end

  describe "assigned a false" do
    before :each do
      @model.bool = false
    end

    include_examples "valid model"
  end

  describe "assigned a nil" do
    before :each do
      @model.bool = nil
    end

    include_examples "valid model"
  end
end

describe "A model with a required Boolean property" do
  before :each do
    @model = HasRequiredBoolean.new(:id => 1)
  end

  describe "assigned a true" do
    before :each do
      @model.bool = true
    end

    include_examples "valid model"
  end

  describe "assigned a false" do
    before :each do
      @model.bool = false
    end

    include_examples "valid model"
  end

  describe "assigned a nil" do
    before :each do
      @model.bool = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message" do
      @model.errors.on(:bool).should == [ 'Bool must not be nil' ]
    end
  end
end

describe "A model with a required paranoid Boolean property" do
  before :each do
    @model = HasRequiredParanoidBoolean.new(:id => 1)
  end

  describe "assigned a true" do
    before :each do
      @model.bool = true
    end

    include_examples "valid model"
  end

  describe "assigned a false" do
    before :each do
      @model.bool = false
    end

    include_examples "valid model"
  end

  describe "assigned a nil" do
    before :each do
      @model.bool = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message" do
      @model.errors.on(:bool).should == [ 'Bool must not be nil' ]
    end
  end
end
