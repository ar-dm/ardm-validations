# encoding: utf-8

require 'spec_helper'
require 'integration/length_validator/spec_helper'

RSpec.shared_examples_for "entity with wrong destination MAC address length" do
  it "has error message with range bounds" do
    expect(@model.errors.on(:destination_mac)).to eq([ 'Destination mac must be 6 characters long' ])
  end
end


describe 'DataMapper::Validations::Fixtures::EthernetFrame' do
  before :all do
    DataMapper::Validations::Fixtures::EthernetFrame.auto_migrate!

    @model = DataMapper::Validations::Fixtures::EthernetFrame.valid_instance
    @model.link_support_fragmentation = false
  end

  include_examples "valid model"

  describe "with destination MAC 3 'bits' long" do
    before :all do
      @model.destination_mac = "123"
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "entity with wrong destination MAC address length"
  end

  describe "with destination MAC 8 'bits' long" do
    before :all do
      @model.destination_mac = "123abce8"
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "entity with wrong destination MAC address length"
  end

  # arguable but reasonable for 80% of cases
  # to treat nil as a 0 lengh value
  # reported in
  # http://datamapper.lighthouseapp.com/projects/20609/tickets/646
  describe "that has no destination MAC address" do
    before :all do
      @model.destination_mac = nil
      @model.valid?
    end

    include_examples "invalid model"

    include_examples "entity with wrong destination MAC address length"
  end

  describe "with a 6 'bits' destination MAC address" do
    before :all do
      @model.destination_mac = "a1b2c3"
      @model.valid?
    end

    include_examples "valid model"
  end

  describe "with multibyte characters" do
    before :all do
      begin
        # force normal encoding in this block
        original, $KCODE = $KCODE, 'N' if RUBY_VERSION <= '1.8.6'

        # example from: http://intertwingly.net/stories/2004/04/14/i18n.html
        @model = DataMapper::Validations::Fixtures::Multibyte.new(
          :name => 'Iñtërnâtiônàlizætiøn'
        )
        expect(@model).to be_valid
      ensure
        $KCODE = original if RUBY_VERSION <= '1.8.6'
      end
    end

    include_examples "valid model"
  end
end
