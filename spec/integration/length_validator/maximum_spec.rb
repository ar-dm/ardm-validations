require 'spec_helper'
require 'integration/length_validator/spec_helper'

RSpec.shared_examples_for "barcode with invalid code length" do
  it "has a meaninful error message with length restrictions mentioned" do
    expect(@model.errors.on(:code)).to eq([ 'Code must be at most 10 characters long' ])
  end
end

describe 'DataMapper::Validations::Fixtures::Barcode' do
  before :all do
    DataMapper::Validations::Fixtures::Barcode.auto_migrate!

    @model = DataMapper::Validations::Fixtures::Barcode.valid_instance
  end

  include_examples "valid model"

  describe "with a 17 characters long code" do
    before :all do
      @model.code = "18283849284728124"
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "barcode with invalid code length"
  end

  describe "with a 7 characters long code" do
    before :all do
      @model.code = "8372786"
      @model.valid?
    end

    include_examples "valid model"
  end

  describe "with an 11 characters long code" do
    before :all do
      @model.code = "83727868754"
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "barcode with invalid code length"
  end
end
