# -*- coding: utf-8 -*-

require 'spec_helper'
require 'integration/duplicated_validations/spec_helper'

describe 'DataMapper::Validations::Fixtures::Page' do
  before :all do
    DataMapper::Validations::Fixtures::Page.auto_migrate!

    @model = DataMapper::Validations::Fixtures::Page.new(:id => 1024)
  end

  describe "without body" do
    before :all do
      @model.body = nil
    end

    include_examples "invalid model"

    it "does not have duplicated error messages" do
      expect(@model.errors.on(:body)).to eq(["Body must not be blank"])
    end
  end
end
