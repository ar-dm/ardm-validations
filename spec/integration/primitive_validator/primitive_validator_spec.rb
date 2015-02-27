require 'spec_helper'
require 'integration/primitive_validator/spec_helper'

describe 'DataMapper::Validations::Fixtures::MemoryObject' do
  include DataMapper::Validations::Fixtures

  before :all do
    DataMapper::Validations::Fixtures::MemoryObject.auto_migrate!
  end

  before :each do
    @model = DataMapper::Validations::Fixtures::MemoryObject.new
  end

  describe "with color given as a string" do
    before :each do
      @model.color = "grey"
    end

    it "is valid" do
      expect(@model).to be_valid
    end
  end


  describe "with color given as an object" do
    before :each do
      # we have to go through the back door
      # since writer= method does typecasting
      # and Object is casted to String
      @model.instance_variable_set(:@color,  Object.new)
    end

    it "is NOT valid" do
      expect(@model).not_to be_valid
    end
  end


  describe "with mark flag set to true" do
    before :each do
      @model.marked = true
    end

    it "is valid" do
      expect(@model).to be_valid
    end
  end


  describe "with mark flag set to false" do
    before :each do
      @model.marked = false
    end

    it "is valid" do
      expect(@model).to be_valid
    end
  end

  describe "with mark flag set to an object" do
    before :each do
      # go through the back door to avoid typecasting
      @model.instance_variable_set(:@marked, Object.new)
    end

    it "is NOT valid" do
      expect(@model).not_to be_valid
    end
  end


  describe "with color set to nil" do
    before :each do
      # go through the back door to avoid typecasting
      @model.color = nil
    end

    it "is valid" do
      expect(@model).to be_valid
    end
  end


  describe "with mark flag set to nil" do
    before :each do
      @model.marked = nil
    end

    it "is valid" do
      expect(@model).to be_valid
    end
  end
end
