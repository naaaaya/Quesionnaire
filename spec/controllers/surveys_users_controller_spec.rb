require 'rails_helper'

describe SurveysUsersController do
  let(:user) { create(:user) }
  let!(:survey) { create(:survey, status: 1) }
  let!(:questions) { create_list(:question, 2, survey_id: survey.id) }

  before do
    login_user(user)
  end

  describe 'GET #new' do
    subject { get :new, params: { survey_id: survey.id } }
    it 'redirects to surveys_path unless survey are published' do
      survey.draft!
      subject
      expect(response).to redirect_to surveys_path
    end

    it 'redirects surveys_path after user answered' do
      user.surveys_users.create(survey_id: survey.id, answered_flag: true)
      subject
      expect(response).to redirect_to surveys_path
    end
  end

  describe 'POST#create' do
    let!(:question) { create(:question, survey_id: survey.id, question_type: 3) }
    let!(:questions_choise) { create(:questions_choise, question_id: question.id) }
    let(:surveys_user) { user.surveys_users.create(survey_id: survey.id) }

    it 'redirects to surveys_path after user answered' do
      surveys_user.update(answered_flag: true)
      params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                surveys_user: { question.id.to_s => {question_type: question.question_type, choise_id: questions_choise.id}}}
      post :create, params
      expect(response).to redirect_to surveys_path
    end

    context 'success to save answer' do
      it 'redirects to previous page' do
        params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                  surveys_user: { question.id.to_s => {question_type: question.question_type, choise_id: questions_choise.id}},
                  current_page: 2, previous_page: '前の10件'}
        path = "#{new_survey_surveys_user_path(survey_id: survey.id)}/?page=1"
        post :create, params: params
        expect(response).to redirect_to path
      end

      it 'redirects to next page' do
        params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                  surveys_user: { question.id.to_s => {question_type: question.question_type, choise_id: questions_choise.id}},
                  current_page: 1, next_page: '次の10件'}
        path = "#{new_survey_surveys_user_path(survey_id: survey.id)}/?page=2"
        post :create, params: params
        expect(response).to redirect_to path
      end
    end

    context 'fails to save answer' do
      it 'renders new_survey_surveys_user_path' do
        post :create, params: { survey_id: survey.id, surveys_user_id: surveys_user.id}
        expect(response).to render_template :new
      end
    end


    context 'set answer_params' do
      it 'return answer_params for text_answer' do
        question.text_field!
        params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                  surveys_user: { question.id.to_s => {question_type: question.question_type, choise_id: questions_choise.id}}}
        post :create, params: params
        expect(assigns(:survey)).to eq survey
      end

      it 'return answer_params for checkbox answer' do
        questions_choises = create_list(:questions_choise, 2, question_id: question.id)
        question.checkbox!
        params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                  surveys_user:{ question.id.to_s => {question_type: question.question_type,
                  choise_ids: [question.questions_choises.pluck(:id)]}}}
        post :create, params: params
        expect(assigns(:survey)).to eq survey
      end

      it 'return answer_params for radio_button answer' do
        question.radio_button!
        params = { survey_id: survey.id, surveys_user_id: surveys_user.id ,
                  surveys_user: { question.id.to_s => {question_type: question.question_type, choise_id: questions_choise.id}}}
        post :create, params: params
        expect(assigns(:survey)).to eq survey
      end
    end
  end
end