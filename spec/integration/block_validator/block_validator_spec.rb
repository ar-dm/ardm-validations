require 'spec_helper'
require 'integration/block_validator/spec_helper'

describe 'DataMapper::Validations::Fixtures::G3Concert' do
  before :all do
    @model = DataMapper::Validations::Fixtures::G3Concert.new(:year => 2004, :participants => "Joe Satriani, Steve Vai, Yngwie Malmsteen", :city => "Denver")
    expect(@model).to be_valid
  end

  describe "some non existing year/participants/city combination" do
    before :all do
      @model.year = 2015
    end

    include_examples "invalid model"

    it "uses error messages returned by the validation block" do
      expect(@model.errors.on(:participants)).to eq([ 'this G3 is probably yet to take place' ])
    end
  end


  describe "existing year/participants/city combination" do
    before :all do
      @model.year         = 2001
      @model.city         = "Los Angeles"
      @model.participants = "Joe Satriani, Steve Vai, John Petrucci"
    end

    include_examples "valid model"
  end

  describe "planned concert for non-existing year/participants/city combinations" do
    before :all do
      @model.planned = true
      @model.year         = 2021
    end

    include_examples "valid model"
  end
end
