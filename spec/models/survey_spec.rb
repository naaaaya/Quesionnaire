require 'rails_helper'

describe Survey do
  it 'is valid with title and description' do
    survey = build(:survey)
    expect(survey).to be_valid
  end

  it 'is invalid without title' do
    survey = build(:survey, title: nil)
    survey.valid?
    expect(survey.errors[:title]).to include("を入力してください")
  end

  it 'is invalid without description' do
    survey = build(:survey, description: nil)
    survey.valid?
    expect(survey.errors[:description]).to include("を入力してください")
  end

end