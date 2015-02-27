require 'spec_helper'
require 'integration/automatic_validation/spec_helper'

describe 'SailBoat' do
  before :all do
    SailBoat.auto_migrate!

    @model = SailBoat.new(:id => 1)
    expect(@model).to be_valid_for_primitive_test
  end

  describe "with invlid value assigned to primitive column" do
    before :all do
      @model.build_date = 'ABC'
    end

    it "is invalid" do
      expect(@model).not_to be_valid_for_primitive_test
      expect(@model.errors.on(:build_date)).to eq([ 'Build date must be of type Date' ])
    end
  end
end
