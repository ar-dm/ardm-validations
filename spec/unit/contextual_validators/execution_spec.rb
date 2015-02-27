# -*- coding: utf-8 -*-
require 'spec_helper'
require 'unit/contextual_validators/spec_helper'

describe 'DataMapper::Validations::ContextualValidators' do
  before :each do
    @validators = DataMapper::Validations::ContextualValidators.new
  end

  describe "#execute(name, target)" do
    before do
      @validator_one = DataMapper::Validations::PresenceValidator.new(:name)
      @validator_two = DataMapper::Validations::WithinValidator.new(:operating_system, :set => ["Mac OS X", "Linux", "FreeBSD", "Solaris"])

      @validators.context(:default) << @validator_one << @validator_two
    end


    describe "when target satisfies all validators" do
      before do
        @target = DataMapper::Validations::Fixtures::PieceOfSoftware.new(:name => 'gcc', :operating_system => "Mac OS X")
        expect(@validator_one.call(@target)).to be(true)
        expect(@validator_two.call(@target)).to be(true)

        @result = @validators.execute(:default, @target)
      end

      it "returns true" do
        expect(@result).to be(true)
      end
    end


    describe "when target does not satisfy all validators" do
      before do
        @target = DataMapper::Validations::Fixtures::PieceOfSoftware.new(:name => 'Skitch', :operating_system => "Haiku")
        expect(@validator_one.call(@target)).to be(true)
        expect(@validator_two.call(@target)).to be(false)

        @result = @validators.execute(:default, @target)
      end

      it "returns true" do
        expect(@result).to be(false)
      end
    end
  end
end
