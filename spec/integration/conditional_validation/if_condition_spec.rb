require 'spec_helper'
require 'integration/conditional_validation/spec_helper'

describe 'DataMapper::Validations::Fixtures::UDPPacket' do
  before :all do
    DataMapper::Validations::Fixtures::UDPPacket.auto_migrate!

    @model = DataMapper::Validations::Fixtures::UDPPacket.new
  end

  describe "that is transported encapsulated into IPv4 packet" do
    before :all do
      @model.underlying_ip_version = 4
    end

    describe "and has no checksum" do
      before :all do
        @model.checksum = nil
      end

      include_examples "valid model"
    end

    describe "and has no checksum algorithm" do
      before :all do
        @model.checksum_algorithm = nil
      end

      include_examples "valid model"
    end
  end


  describe "that is transported encapsulated into IPv6 packet" do
    before :all do
      @model.underlying_ip_version = 6
    end

    describe "and has no checksum" do
      before :all do
        @model.checksum = nil
      end

      include_examples "invalid model"

      it "has a meaningful error message" do
        expect(@model.errors.on(:checksum)).to eq([ 'Checksum is mandatory when used with IPv6' ])
      end
    end

    describe "and has no checksum algorithm" do
      before :all do
        @model.checksum_algorithm = nil
      end

      include_examples "invalid model"

      it "has a meaningful error message" do
        expect(@model.errors.on(:checksum_algorithm)).to eq([ 'Checksum is mandatory when used with IPv6' ])
      end
    end
  end
end
