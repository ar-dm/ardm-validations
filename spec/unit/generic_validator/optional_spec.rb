require 'spec_helper'

describe 'DataMapper::Validations::GenericValidator', '#optional?' do
  def validator(opts = {})
    DataMapper::Validations::LengthValidator.new(:name, opts)
  end

  describe 'allowing blank' do
    subject do
      validator(
        :allow_blank => true
      )
    end

    it { expect(subject.optional?("" )).to be }
    it { expect(subject.optional?(nil)).to be }
  end

  describe 'allowing nil' do
    subject do
      validator(
        :allow_nil => true
      )
    end

    it { expect(subject.optional?("" )).not_to be }
    it { expect(subject.optional?(nil)).to be }
  end

  describe 'allowing blank, but now allowing nil' do
    subject do
      validator(
        :allow_blank => true,
        :allow_nil   => false
      )
    end

    it { expect(subject.optional?("" )).to be }
    it { expect(subject.optional?(nil)).not_to be }
  end

  describe 'allowing nil, but now allowing blank' do
    subject do
      validator(
        :allow_blank => false,
        :allow_nil   => true
      )
    end

    it { expect(subject.optional?("" )).not_to be }
    it { expect(subject.optional?(nil)).to be }
  end

end
