require 'rails_helper'

describe SurveysController do
  let(:user) { create(:user) }
  before do
    login_user(user)
  end
  describe 'GET #index' do
    let(:surveys) { create_list(:survey, 2, status: 1) }
    subject { get :index }
    it 'assigns answered surveys to @answered_surveys' do
      answered_surveys = []
      surveys.each do |survey|
        answered_surveys << survey.surveys_users.create(user_id: user.id, answered_flag: true)
      end
      subject
      expect(assigns(:answered_surveys)).to eq answered_surveys
    end
    it 'assigns draft surveys to @draft_surveys' do
      draft_surveys = []
      surveys.each do |survey|
        draft_surveys << survey.surveys_users.create(user_id: user.id, answered_flag: false)
      end
      subject
      expect(assigns(:draft_surveys)).to eq draft_surveys
    end
    it 'assigns unanswered surveys to @unanswered_surveys' do
      surveys.each do |survey|
        survey.surveys_companies.create(company_id: user.company.id)
      end
      subject
      expect(assigns(:unanswered_surveys)).to eq surveys
    end
  end

  describe 'GET #show' do
    let(:survey) { create(:survey) }
    subject { get :show, params: { id: survey.id } }
    it { subject
        expect(assigns(:survey)).to eq survey
        }
    it { expect(subject).to redirect_to surveys_path }
  end

end