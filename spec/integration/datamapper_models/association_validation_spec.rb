require 'spec_helper'

describe 'DataMapper::Validations::Fixtures::Product' do
  before :all do
    DataMapper::Validations::Fixtures::ProductCompany.auto_migrate!
    DataMapper::Validations::Fixtures::Product.auto_migrate!

    parent_model = DataMapper::Validations::Fixtures::ProductCompany
    @parent = parent_model.new(:title => "Apple", :flagship_product => "Macintosh")
    expect(@parent).to be_valid
    expect(@parent.save).to be_truthy

    model_model = DataMapper::Validations::Fixtures::Product
    @model = model_model.new(:name => "MacBook Pro", :company => @parent)
    expect(@model).to be_valid
  end

  describe "without company" do
    before :all do
      @model.company = nil
    end

    include_examples "invalid model"

    it "has a meaningful error message" do
      expect(@model.errors.on(:company)).to eq([ 'Company must not be blank' ])
    end
  end
end
