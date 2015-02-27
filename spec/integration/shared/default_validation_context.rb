RSpec.shared_examples_for "object invalid in default context" do
  it "is not valid in default context" do
    @model.should_not be_valid
    @model.should_not be_valid(:default)
  end
end

RSpec.shared_examples_for "object valid in default context" do
  it "is valid in default context" do
    @model.should be_valid
    @model.should be_valid(:default)
  end
end
