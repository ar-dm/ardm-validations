require 'spec_helper'
require 'integration/confirmation_validator/spec_helper'

RSpec.shared_examples_for "reservation with mismatched person name" do
  it "has meaningful error message" do
    expect(@model.errors.on(:person_name)).to eq([ 'Person name does not match the confirmation' ])
  end
end

RSpec.shared_examples_for "reservation with mismatched seats number" do
  it "has meaningful error message" do
    # Proc gets expanded here
    expect(@model.errors.on(:number_of_seats)).to eq([ 'Reservation requires confirmation for number_of_seats' ])
  end
end


describe 'DataMapper::Validations::Fixtures::Reservation' do
  before :each do
    DataMapper::Validations::Fixtures::Reservation.auto_migrate!

    @model = DataMapper::Validations::Fixtures::Reservation.new(:person_name                  => "Tyler Durden",
                                                             :person_name_confirmation     => "Tyler Durden",
                                                             :number_of_seats              => 2,
                                                             :seats_confirmation           => 2)
    expect(@model).to be_valid
  end

  describe "with matching person name and confirmation" do
    before :each do
      @model.person_name = "mismatch"
    end

    include_examples "invalid model"
    include_examples "reservation with mismatched person name"
  end


  describe "with a blank person name and confirmation" do
    before :each do
      @model.person_name = ""
    end

    include_examples "invalid model"
    include_examples "reservation with mismatched person name"
  end


  describe "with a missing person name and confirmation" do
    before :each do
      @model.person_name = nil
    end

    include_examples "invalid model"
    include_examples "reservation with mismatched person name"
  end


  describe "with mismatching number of seats and confirmation" do
    before :each do
      @model.number_of_seats  = -1
    end

    include_examples "invalid model"
    include_examples "reservation with mismatched seats number"
  end


  describe "with a blank number of seats and confirmation" do
    before :each do
      @model.number_of_seats = nil
    end

    include_examples "valid model"
  end
end
