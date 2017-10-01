require 'rails_helper'

describe Survey do
    it { expect(build(:survey)).to be_valid }

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

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:survey) { create(:survey) }

    describe '#draft_surveys_user' do
      it 'return surveys_user when user has already created draft' do
        surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id)
        expect(survey.draft_surveys_user(user)).to eq surveys_user
      end
        it { expect {
          survey.draft_surveys_user(user)
        }.to change(SurveysUser, :count).by(1) }
    end

    describe '#answered_surveys_user' do
      it 'return surveys_user when user has already created draft' do
        surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id, answered_flag: 1)
        expect(survey.answered_surveys_user(user)).to eq surveys_user
      end
      it { expect {
          survey.answered_surveys_user(user)
      }.to change(SurveysUser, :count).by(1) }
    end

    describe '#get_surveys_user_by_status' do
      it 'call #draft_surveys_user when user save draft' do
        params = {}
        expect(survey).to receive(:draft_surveys_user)
        survey.get_surveys_user_by_status(params, user)
      end
      it 'call #answered_surveys_user when user send answer' do
        params = {send: '回答する'}
        expect(survey).to receive(:answered_surveys_user)
        survey.get_surveys_user_by_status(params, user)
      end
    end

  end
end