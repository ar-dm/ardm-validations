require 'spec_helper'
require 'integration/automatic_validation/spec_helper'

describe 'Inferred validations' do
  it "allow overriding a single error message" do
    custom_boat = Class.new do
      include DataMapper::Resource

      def self.name
        'Boat'
      end

      property :id,   DataMapper::Property::Serial
      property :name, String, :required => true, :message => "This boat must have name"
    end
    boat = custom_boat.new
    expect(boat).not_to be_valid
    expect(boat.errors.on(:name)).to eq([ 'This boat must have name' ])
  end

  it "should have correct error messages" do
    custom_boat = Class.new do
      include DataMapper::Resource

      def self.name
        'Boat'
      end

      property :id,   DataMapper::Property::Serial
      property :name, String, :required => true, :length => 5..20, :format => /^[a-z]+$/,
               :messages => {
                 :presence => "This boat must have name",
                 :length => "Name must have at least 4 and at most 20 chars",
                 :format => "Please use only small letters"
               }
    end

    boat = custom_boat.new
    expect(boat).not_to be_valid
    expect(boat.errors.on(:name)).to eq([ 'This boat must have name' ])

    boat.name = "%%"
    expect(boat).not_to be_valid
    expect(boat.errors.on(:name)).to eq([
      'Name must have at least 4 and at most 20 chars',
      'Please use only small letters',
    ])

    boat.name = "%%asd"
    expect(boat).not_to be_valid
    expect(boat.errors.on(:name)).to eq([ 'Please use only small letters' ])

    boat.name = "superboat"
    expect(boat).to be_valid
    expect(boat.errors.on(:name)).to be_nil
  end
end
