require 'spec_helper'

describe 'DataMapper::Validations::Fixtures::ServiceCompany' do
  before :all do
    DataMapper::Validations::Fixtures::ServiceCompany.auto_migrate!

    @model = DataMapper::Validations::Fixtures::ServiceCompany.new(:title => "Monsters, Inc.", :area_of_expertise => "Little children's nightmares")
    @model.valid?
  end

  describe "without title" do
    before :all do
      @model.title = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message for inherited property" do
      expect(@model.errors.on(:title)).to eq([ 'Company name is a required field' ])
    end
  end

  describe "without area of expertise" do
    before :all do
      @model.area_of_expertise = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message for own property" do
      expect(@model.errors.on(:area_of_expertise)).to eq([ 'Area of expertise must not be blank' ])
    end
  end
end



describe 'DataMapper::Validations::Fixtures::ProductCompany' do
  before :all do
    DataMapper::Validations::Fixtures::ProductCompany.auto_migrate!

    @model = DataMapper::Validations::Fixtures::ProductCompany.new(:title => "Apple", :flagship_product => "Macintosh")
    @model.valid?
  end

  include_examples "valid model"

  describe "without title" do
    before :all do
      @model.title = nil
    end

    include_examples "invalid model"

    it "has error message from the subclass itself" do
      expect(@model.errors.on(:title)).to include('Product company must have a name')
    end

    # this may or may not be a desired behavior,
    # but append vs. replace is a matter of opinion
    # anyway
    #
    # TODO: there should be a way to clear validations for a field
    # that subclasses can use
    it "has error message from superclass" do
      expect(@model.errors.on(:title)).to include('Company name is a required field')
    end
  end


  describe "without flagship product" do
    before :all do
      @model.flagship_product = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message for own property" do
      expect(@model.errors.on(:flagship_product)).to eq([ 'Flagship product must not be blank' ])
    end
  end
end
