require 'rails_helper'

describe Admins::SurveysController do
  let(:admin) { create(:admin) }
  let(:survey) { create(:survey) }

  before do
    login_admin(admin)
  end

  describe 'GET #index' do
      subject { get :index }
    context 'with specific surveys' do
      it 'assigns the draft surveys to @draft_surveys' do
        draft_surveys = create_list(:survey, 2, status: 0)
        subject
        expect(assigns(:draft_surveys)).to eq(draft_surveys)
      end
      it 'assigns the published surveys to @published_surveys' do
        published_surveys = create_list(:survey, 2, status: 1)
        subject
        expect(assigns(:published_surveys)).to eq(published_surveys)
      end
      it 'assigns the unlisted surveys to @unlisted_surveys' do
        unlisted_surveys = create_list(:survey, 2, status: 2)
        subject
        expect(assigns(:unlisted_surveys)).to eq(unlisted_surveys)
      end
    end
    it { expect(subject).to render_template :index }
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'renders the :show template' do
      survey.published!
      get :show, params: { id: survey.id }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: survey.id } }
    it { expect(subject).to render_template :edit }

    it 'redirects to index unless survey is draft' do
      survey.published!
      expect(subject).to redirect_to admins_surveys_path
    end
  end

  describe 'POST#create' do
    let(:questions) {[
      attributes_for(:question),
      attributes_for(:question),
      attributes_for(:question, choises: [attributes_for(:questions_choise), attributes_for(:questions_choise)])
    ]}
    it 'redirects to admins_surveys_path after survey is saved' do
      post :create, params: { survey: attributes_for(:survey), questions: questions}
      expect(response).to redirect_to admins_surveys_path
    end
    it 're-renders admins_surveys_path' do
      post :create, params: { survey: attributes_for(:invalid_survey), questions: questions}
      expect(response).to render_template :new
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, survey_id: survey.id) }
    let(:questions_choise) { create(:questions_choise, question_id: question.id) }
    let(:questions) {[
        attributes_for(:question),
        attributes_for(:question),
        attributes_for(:question, choises: [attributes_for(:questions_choise), attributes_for(:questions_choise)])
      ]}
    context 'with valid attributes' do
      it "changes question's attributes" do
        patch :update, params: { id: survey.id, survey: attributes_for(:survey, title: 'aaa', description: 'bbb'), questions: [ { id: question.id, description: 'aaa' } ] }
        question.reload
        expect(question.description).to eq('aaa')
      end
      it 'redirects to admins_survey_path' do
         patch :update, params: { id: survey.id, survey: attributes_for(:survey), questions: questions }
         expect(response).to redirect_to admins_survey_path
      end
    end

    context 'with invalid attributes' do
      let(:params) { {id: survey.id, survey: attributes_for(:survey, title: nil), questions: questions} }
      before do
        patch :update, params: params
      end
      it { expect(assigns(:survey).errors[:title]).to include "を入力してください" }
      it { expect(response).to render_template :edit }
    end

    it 'unlist survey' do
      patch :update, params: { id: survey.id, survey: attributes_for(:survey), unlist_survey: "非表示" }
      survey.reload
      expect(survey.unlisted?).to be true
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, survey_id: survey.id) }
    let!(:user) { create(:user) }
    let!(:questions_choise) { create(:questions_choise, question_id: question.id) }
    let!(:surveys_user) { survey.surveys_users.create(user_id: user.id) }
    let!(:choise_answer) { questions_choise.choise_answers.create(surveys_user_id: surveys_user.id, question_id: question.id) }
    subject { delete :destroy, params: { id: survey.id } }

    it 'redirects to admins_surveys_path' do
      subject
      expect(response).to redirect_to admins_surveys_path
    end

    it 'renders to admins_survey_path when destroy fails' do
      allow_any_instance_of(Survey).to receive(:destroy!).and_raise(ActiveRecord::RecordNotSaved, "error")
      subject
      expect(response).to render_template :edit
    end
  end
end