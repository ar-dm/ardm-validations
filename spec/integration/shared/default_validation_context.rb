RSpec.shared_examples_for "object invalid in default context" do
  it "is not valid in default context" do
    expect(@model).not_to be_valid
    expect(@model).not_to be_valid(:default)
  end
end

RSpec.shared_examples_for "object valid in default context" do
  it "is valid in default context" do
    expect(@model).to be_valid
    expect(@model).to be_valid(:default)
  end
end
