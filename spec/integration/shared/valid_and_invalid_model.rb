RSpec.shared_examples_for "valid model" do
  before do
    @model.valid?
  end

  it "is valid" do
    expect(@model).to be_valid
  end

  it "has no error messages" do
    expect(@model.errors).to be_empty
  end

  it "has empty list of full error messages" do
    expect(@model.errors.full_messages).to be_empty
  end
end

RSpec.shared_examples_for "invalid model" do
  before do
    @model.valid?
  end

  it "is NOT valid" do
    expect(@model).not_to be_valid
  end

  it "has error messages" do
    expect(@model.errors).not_to be_empty
  end

  it "has list of full error messages" do
    expect(@model.errors.full_messages).not_to be_empty
  end
end
