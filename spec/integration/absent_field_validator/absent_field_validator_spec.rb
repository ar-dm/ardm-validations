require 'spec_helper'
require 'integration/absent_field_validator/spec_helper'

describe 'DataMapper::Validations::Fixtures::Kayak' do
  before :each do
    DataMapper::Validations::Fixtures::Kayak.auto_migrate!
  end

  before :each do
    @kayak = DataMapper::Validations::Fixtures::Kayak.new
    @kayak.should be_valid_for_sale
  end

  describe "with salesman being non blank" do
    before :each do
      @kayak.salesman = 'Joe'
    end

    it "is invalid" do
      @kayak.should_not be_valid_for_sale
    end

    it "has meaningful error message" do
      @kayak.errors.on(:salesman).should == [ 'Salesman must be absent' ]
    end
  end


  describe "with salesman being nil" do
    before :each do
      @kayak.salesman = nil
    end

    it "is valid" do
      @kayak.should be_valid_for_sale
    end

    it "has no error messages" do
      @kayak.errors.on(:salesman).should be_nil
    end
  end


  describe "with salesman being an empty string" do
    before :each do
      @kayak.salesman = ''
    end

    it "is valid" do
      @kayak.should be_valid_for_sale
    end

    it "has no error messages" do
      @kayak.errors.on(:salesman).should be_nil
    end
  end


  describe "with salesman being a string of white spaces" do
    before :each do
      @kayak.salesman = '    '
    end

    it "is valid" do
      @kayak.should be_valid_for_sale
    end

    it "has no error messages" do
      @kayak.errors.on(:salesman).should be_nil
    end
  end
end


describe 'DataMapper::Validations::Fixtures::Pirogue' do
  before :each do
    DataMapper::Validations::Fixtures::Pirogue.auto_migrate!
  end

  before :each do
    @kayak = DataMapper::Validations::Fixtures::Pirogue.new
    @kayak.should_not be_valid_for_sale
  end

  describe "by default" do
    it "is invalid" do
      @kayak.should_not be_valid_for_sale
    end

    it "has meaningful error message" do
      @kayak.errors.on(:salesman).should == [ 'Salesman must be absent' ]
    end
  end
end
