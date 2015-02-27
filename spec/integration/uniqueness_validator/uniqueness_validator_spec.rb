require 'spec_helper'
require 'integration/uniqueness_validator/spec_helper'


describe 'uniqueness_validator/uniqueness_validator_spec' do

  describe 'DataMapper::Validations::Fixtures::Department' do
    before :all do
      DataMapper::Validations::Fixtures::Department.destroy!

      expect(DataMapper::Validations::Fixtures::Department.create(:name => "HR")).to be_saved
    end

    describe "with unique name" do
      before do
        @model = DataMapper::Validations::Fixtures::Department.new(:name => "R & D")
      end

      include_examples "valid model"
    end

    describe "with a duplicate name" do
      before do
        @model = DataMapper::Validations::Fixtures::Department.new(:name => "HR")
      end

      include_examples "invalid model"
    end
  end

  describe 'DataMapper::Validations::Fixtures::Organisation' do
    before :all do
      DataMapper::Validations::Fixtures::Organisation.destroy!

      @model = DataMapper.repository do
        DataMapper::Validations::Fixtures::Organisation.create(:name => 'Apple', :domain => 'apple.com')
      end
    end

    describe "with missing domain" do
      before do
        @model.domain = nil
      end

      include_examples "valid model"
    end

    describe "with a duplicate domain" do
      before do
        @model = DataMapper::Validations::Fixtures::Organisation.new(:name => 'Fake Apple', :domain => 'apple.com')
      end

      include_examples "invalid model"

      it "has a meaningful error message" do
        @model.valid?
        expect(@model.errors.on(:domain)).to eq([ 'Domain is already taken' ])
      end
    end

    it "shouldn't fail on itself when checking for records with identical fields" do
      @model.name = "Steve Job's Pony Express"
      expect(@model).to be_valid
    end
  end

  describe 'DataMapper::Validations::Fixtures::User' do
    before :all do
      DataMapper::Validations::Fixtures::Organisation.destroy!
      DataMapper::Validations::Fixtures::Department.destroy!
      DataMapper::Validations::Fixtures::User.destroy!

      DataMapper.repository do
        @organization = DataMapper::Validations::Fixtures::Organisation.create(:name => 'Org 101', :domain => '101')
        @dept         = DataMapper::Validations::Fixtures::Department.create(:name => 'accounting')
        @user         = DataMapper::Validations::Fixtures::User.create(:organisation => @organization, :user_name => 'guy', :department => @dept)

        expect(@organization).to be_saved
        expect(@dept).to be_saved
        expect(@user).to be_saved
      end
    end

    describe "with username not valid across the organization" do
      before do
        @model = DataMapper::Validations::Fixtures::User.new(:organisation => @organization, :user_name => 'guy')
      end

      it "is not valid for signing up" do
        expect(@model).not_to be_valid_for_signing_up_for_organization_account
      end

      it "has a meaningful error message" do
        @model.valid?(:signing_up_for_organization_account)
        expect(@model.errors.on(:user_name)).to eq([ 'User name is already taken' ])
      end
    end


    describe "with username not valid across the department" do
      before do
        @model = DataMapper::Validations::Fixtures::User.new(:user_name => 'guy', :department => @dept)
      end

      it "is not valid for setting up the account" do
        expect(@model).not_to be_valid_for_signing_up_for_department_account
      end

      it "has a meaningful error message" do
        @model.valid?(:signing_up_for_department_account)
        expect(@model.errors.on(:user_name)).to eq([ 'User name is already taken' ])
      end
    end
  end

end
