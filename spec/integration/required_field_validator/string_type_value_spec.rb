require 'spec_helper'
require 'integration/required_field_validator/spec_helper'

describe 'required_field_validator/string_type_value_spec' do

  # keep in mind any ScmOperation has a default value for brand property
  # so it is used
  describe 'GitOperation' do
    before :all do
      GitOperation.auto_migrate!
    end

    before do
      @operation = GitOperation.new(:network_connection => true,
                                    :clean_working_copy => true,
                                    :message            => "I did it! I did it!! Hell yeah!!!")
    end

    describe "without explicitly specified committer name" do
      before do
        # no specific actions for this case! yay!
      end

      it "is valid for committing (because default value jumps in)" do
        expect(@operation).to be_valid_for_committing
        expect(@operation).to be_valid(:committing)
      end

      it "is not valid in default context" do
        # context here is :default
        expect(@operation).not_to be_valid
      end

      it "has default value set" do
        # this is more of a sanity check since
        # this sort of functionality clearly needs to be
        # tested in
        expect(@operation.committer_name).to eq("Just another Ruby hacker")
      end
    end

    describe "WITH explicitly specified committer name" do
      before do
        @operation.committer_name = "Core Team Guy"
      end

      it "is valid for committing" do
        expect(@operation).to be_valid_for_committing
        expect(@operation).to be_valid(:committing)
      end

      it "is not valid in default context" do
        expect(@operation).not_to be_valid
        expect(@operation).not_to be_valid(:default)
      end

      it "has value set" do
        # this is more of a sanity check since
        # this sort of functionality clearly needs to be
        # tested in
        expect(@operation.committer_name).to eq("Core Team Guy")
      end
    end



    describe "without explicitly specified author name" do
      before do
        # no specific actions for this case! yay!
      end

      it "is valid for committing (because default value jumps in)" do
        expect(@operation).to be_valid_for_committing
        expect(@operation).to be_valid(:committing)
      end

      it "is not valid in default context" do
        # context here is :default
        expect(@operation).not_to be_valid
        expect(@operation).not_to be_valid(:default)
      end

      it "has default value set" do
        expect(@operation.author_name).to eq("Just another Ruby hacker")
      end
    end

    describe "WITH explicitly specified author name" do
      before do
        @operation.author_name = "Random contributor"
      end

      it "is valid for committing" do
        expect(@operation).to be_valid_for_committing
      end

      it "is not valid in default context" do
        # context here is :default
        expect(@operation).not_to be_valid
      end

      it "has value set" do
        expect(@operation.author_name).to eq("Random contributor")
      end
    end

    describe "with empty committer name" do
      before do
        @operation.committer_name = ""
      end

      it "is NOT valid for committing" do
        # empty string is not considered present for
        # a String value
        expect(@operation).not_to be_valid_for_committing

        # sanity check since this empty vs blank vs nil
        # thing is a shaky ground
        @operation.committer_name = "l33t k0dr"
        expect(@operation).to be_valid_for_committing
      end

      it "IS valid for pushing" do
        expect(@operation).to be_valid_for_pushing
      end

      it "IS valid for pulling" do
        expect(@operation).to be_valid_for_pulling
      end

      it "is not valid in default context" do
        expect(@operation).not_to be_valid
      end
    end


    describe "with empty author name" do
      before do
        @operation.author_name = ""
      end

      it "is NOT valid for committing" do
        # empty string is not considered present for
        # a String value
        expect(@operation).not_to be_valid_for_committing

        # sanity check since this empty vs blank vs nil
        # thing is a shaky ground
        @operation.author_name = "l33t k0dr"
        expect(@operation).to be_valid_for_committing
      end

      it "IS valid for pushing" do
        expect(@operation).to be_valid_for_pushing
      end

      it "IS valid for pulling" do
        expect(@operation).to be_valid_for_pulling
      end

      it "is not valid in default context" do
        expect(@operation).not_to be_valid
      end
    end
  end

end
