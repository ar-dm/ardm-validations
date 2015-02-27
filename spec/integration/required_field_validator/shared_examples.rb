describe 'GitOperation' do
  before do
    GitOperation.auto_migrate!

    @operation = GitOperation.new
  end

  RSpec.shared_examples_for "unnamed SCM operation" do
    before do
      @operation.name = nil
      @operation.valid?
    end

    it "is not valid" do
      expect(@operation).not_to be_valid
    end

    it "is not valid in default validation context" do
      expect(@operation).not_to be_valid(:default)
    end

    it "points to blank name in the error message" do
      expect(@operation.errors.on(:name)).to eq([ 'Name must not be blank' ])
    end
  end
end
