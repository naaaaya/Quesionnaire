require 'rails_helper'

describe Admins::SurveysController do
  let(:admin) { create(:admin) }
  before do
    login_admin(admin)
  end

  describe 'GET #index' do
    before do
      get :index
    end
    context 'with specific surveys' do
      it 'assigns the draft surveys to @draft_surveys' do
        draft_surveys = create_list(:survey, 2, status: 0)
        expect(assigns(:draft_surveys)).to eq(draft_surveys)
      end
      it 'assigns the published surveys to @published_surveys' do
        published_surveys = create_list(:survey, 2, status: 1)
        expect(assigns(:published_surveys)).to eq(published_surveys)
      end
      it 'assigns the unlisted surveys to @unlisted_surveys' do
        unlisted_surveys = create_list(:survey, 2, status: 2)
        expect(assigns(:unlisted_surveys)).to eq(unlisted_surveys)
      end
    end
    it { expect(response).to render_template :index }
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:survey) { create(:survey, status: 1) }
    it 'renders the :show template' do
      get :show, params: { id: survey }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    let(:survey) { create(:survey) }

    it 'renders edit' do
      get :edit, params: { id: survey }
      expect(response).to render_template :edit
    end

    it 'redirects to index unless survey is draft' do
      survey.published!
      get :edit, params: { id: survey }
      expect(response).to redirect_to admins_surveys_path
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

  describe 'PATCH #edit' do
    let(:survey) { create(:survey) }
    let(:question) { create(:question, survey_id: survey.id) }
    let(:questions_choise) { create(:questions_choise, question_id: question.id) }
    let(:questions) {[
        attributes_for(:question),
        attributes_for(:question),
        attributes_for(:question, choises: [attributes_for(:questions_choise), attributes_for(:questions_choise)])
      ]}
    context 'with valid attributes' do
      it "changes question's attributes" do
        patch :update, params: { id: survey, survey: attributes_for(:survey, title: 'aaa', description: 'bbb'), questions: [ { id: question.id, description: 'aaa' } ] }
        question.reload
        expect(question.description).to eq('aaa')
      end
      it 'redirects to admins_survey_path' do
         patch :update, params: { id: survey, survey: attributes_for(:survey), questions: questions }
         expect(response).to redirect_to admins_survey_path
      end
    end

    context 'with invalid attributes' do
      let(:params) { {id: survey, survey: attributes_for(:survey, title: nil), questions: questions} }
      before do
        patch :update, params: params
      end
      it 'returns error message' do
        expect(assigns(:survey).errors[:title]).to include "を入力してください"
      end
      it 're-renders to :edit' do
        expect(response).to render_template :edit
      end
    end

    it 'unlist survey' do
      patch :update, params: { id: survey, survey: attributes_for(:survey), unlist_survey: "非表示" }
      survey.reload
      expect(survey.unlisted?).to be true
    end
  end

  describe 'DELETE #destroy' do
    let!(:survey) { create(:survey) }
    let!(:question) { create(:question, survey_id: survey.id) }
    let!(:user) { create(:user) }
    let!(:questions_choise) { create(:questions_choise, question_id: question.id) }
    let!(:surveys_user) { survey.surveys_users.create(user_id: user.id) }
    let!(:choise_answer) { questions_choise.choise_answers.create(surveys_user_id: surveys_user.id, question_id: question.id) }

    it 'redirects to admins_surveys_path' do
      delete :destroy, params: { id: survey }
      expect(response).to redirect_to admins_surveys_path
    end

    it 'renders to admins_survey_path when destroy fails' do
      allow_any_instance_of(Survey).to receive(:destroy!).and_raise(ActiveRecord::RecordNotSaved, "error")
      delete :destroy, params: { id: survey }
      expect(response).to render_template :edit
    end
  end
end