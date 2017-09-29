require 'rails_helper'

describe Admins::SurveysController do
  let(:admin) { create(:admin) }
  before do
    login_admin(admin)
  end
  describe 'GET #index' do
    it 'assigns the draft surveys to @draft_surveys' do
      draft_surveys = create_list(:survey, 2, status: 0)
      get :index
      expect(assigns(:draft_surveys)).to eq(draft_surveys)
    end
    it 'assigns the published surveys to @published_surveys' do
      published_surveys = create_list(:survey, 2, status: 1)
      get :index
      expect(assigns(:published_surveys)).to eq(published_surveys)
    end
    it 'assigns the unlisted surveys to @unlisted_surveys' do
      unlisted_surveys = create_list(:survey, 2, status: 2)
      get :index
      expect(assigns(:unlisted_surveys)).to eq(unlisted_surveys)
    end
    it 'renders the :index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns new Survey to @survey' do
      get :new
      expect(assigns(:survey)).to be_a_new(Survey)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:survey) { create(:survey, status: 1) }
    it 'assigns the requested survey to @survey' do
      get :show, params: { id: survey }
      expect(assigns(:survey)).to eq(survey)
    end
    it 'assigns added companies to @added_companies' do
      added_companies = create_list(:company, 2)
      added_companies.each do |company|
        survey.surveys_companies.create(company_id: company.id)
      end
      get :show, params: { id: survey }
      expect(assigns(:added_companies)).to eq(added_companies)
    end
    it 'assigns new surveys_company to @surveys_company' do
      get :show, params: { id: survey }
      expect(assigns(:surveys_company)).to be_a_new(SurveysCompany)
    end
    it 'renders the :show template' do
      get :show, params: { id: survey }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    let(:survey) { create(:survey) }
    it 'assigns requested survey to @survey' do
      get :edit, params: { id: survey }
      expect(assigns(:survey)).to eq(survey)
    end
    it 'renders the :edit template' do
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
    context 'with valid attributes' do

      it 'saves the new survey in the database' do
        expect {
          post :create, params: { survey: attributes_for(:survey), questions: questions}
        }.to change(Survey, :count).by(1)
      end
      it 'saves the new questions in the database' do
        expect {
          post :create, params: { survey: attributes_for(:survey), questions: questions}
        }.to change(Question, :count).by(3)
      end
      it 'saves the new choices in database' do
        expect {
          post :create, params: { survey: attributes_for(:survey), questions: questions}
        }.to change(QuestionsChoise, :count).by(2)
      end
      it 'redirects to admins_surveys_path after survey is saved' do
         post :create, params: { survey: attributes_for(:survey), questions: questions}
         expect(response).to redirect_to admins_surveys_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new survey in the database' do
        expect{
          post :create, params: { survey: attributes_for(:invalid_survey), questions: questions }
        }.not_to change(Survey, :count)
      end

      it 'does not save the new question in the database' do
        expect{
          post :create, params: { survey: attributes_for(:invalid_survey), questions: questions }
        }.not_to change(Question, :count)
      end

      it 'does not save the new choices in the database' do
        expect{
          post :create, params: { survey: attributes_for(:invalid_survey), questions: questions }
        }.not_to change(QuestionsChoise, :count)
      end

      it 're-renders admins_surveys_path' do
        post :create, params: { survey: attributes_for(:invalid_survey), questions: questions}
        expect(response).to render_template :new
      end
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
      it "locates the requested @survey" do
        patch :update, params: { id: survey, survey: attributes_for(:survey), questions: questions }
        expect(assigns(:survey)).to eq(survey)
      end
      it "changes @surveys's attributes" do
        patch :update, params: { id: survey, survey: attributes_for(:survey, title: 'aaa', description: 'bbb'), questions: questions }
        survey.reload
        expect(survey.title).to eq('aaa')
        expect(survey.description).to eq('bbb')
      end
      it "changes question's attributes" do
        patch :update, params: { id: survey, survey: attributes_for(:survey, title: 'aaa', description: 'bbb'), questions: [ { id: question.id, description: 'aaa' } ] }
        question.reload
        expect(question.description).to eq('aaa')
      end
      it "changes questions_choise's attributes" do
        patch :update, params: { id: survey, survey: attributes_for(:survey, title: 'aaa', description: 'bbb'),
                                  questions:[{id: question.id, description: 'aaa', choises: [{id: questions_choise.id, description: 'aaa'}]}]
                                }
        questions_choise.reload
        expect(questions_choise.description).to eq('aaa')

      end
      it 'redirects to admins_survey_path' do
         patch :update, params: { id: survey, survey: attributes_for(:survey), questions: questions }
         expect(response).to redirect_to admins_survey_path
      end
    end

    context 'with invalid attributes' do
      it 'returns error message' do
        patch :update, params: { id: survey, survey: attributes_for(:survey, title: nil), questions: questions }
        expect(assigns(:survey)).to eq false
      end
      it 're-renders to :edit'
    end
  end
end