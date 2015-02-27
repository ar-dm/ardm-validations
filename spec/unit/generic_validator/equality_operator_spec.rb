require 'spec_helper'

describe 'DataMapper::Validations::GenericValidator' do
  describe "when types and fields are equal" do
    it "returns true" do
      expect(DataMapper::Validations::PresenceValidator.new(:name)).
        to eq(DataMapper::Validations::PresenceValidator.new(:name))
    end
  end


  describe "when types differ" do
    it "returns false" do
      expect(DataMapper::Validations::PresenceValidator.new(:name)).
        not_to eq(DataMapper::Validations::UniquenessValidator.new(:name))
    end
  end


  describe "when property names differ" do
    it "returns false" do
      expect(DataMapper::Validations::PresenceValidator.new(:first_name)).
        not_to eq(DataMapper::Validations::PresenceValidator.new(:last_name))
    end
  end
end
