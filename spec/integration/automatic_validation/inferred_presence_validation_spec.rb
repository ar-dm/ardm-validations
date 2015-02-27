require 'spec_helper'
require 'integration/automatic_validation/spec_helper'

describe 'SailBoat' do
  before :all do
    SailBoat.auto_migrate!

    @model      = SailBoat.new(:id => 1)
    @model.name = 'Float'
    expect(@model).to be_valid_for_presence_test
  end

  describe "without name" do
    before :all do
      @model.name = nil
    end

    # has validates_is_present for name thanks to :required => true
    it "is invalid" do
      expect(@model).not_to be_valid_for_presence_test
      expect(@model.errors.on(:name)).to eq([ 'Name must not be blank' ])
    end
  end
end



describe 'SailBoat' do
  before :all do
    SailBoat.auto_migrate!

    @model      = SailBoat.new(:id => 1)
    @model.name = 'Float'
    expect(@model).to be_valid_for_presence_test
  end

  describe "with a name" do
    before :all do
      # no op
    end

    # has validates_is_present for name thanks to :required => true
    include_examples "valid model"
  end
end
