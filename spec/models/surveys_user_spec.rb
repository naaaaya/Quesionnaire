require 'rails_helper'

describe SurveysUser do
  let(:survey) { create(:survey) }
  let(:company) { create(:company) }
  let(:user) { create(:user, company_id: company.id) }
  let!(:surveys_user) { SurveysUser.create(survey_id: survey.id, user_id: user.id)}
  let!(:question) { create(:question, survey_id: survey.id) }
  let(:text_answer_params) { { question_id: question.id, description: 'aaa' } }

  it 'is invalid when survey and user are already taken' do
    surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id)
    surveys_user.valid?
    expect(surveys_user.errors[:survey_id]).to include("はすでに存在します")
  end

  it 'is valid when survey and user are unique' do
    expect(surveys_user).to be_valid
  end

  describe '#create_or_update_answer' do
    it 'calls #create_or_update_text_answer when question_type is text_field' do
      expect(surveys_user).to receive(:create_or_update_text_answer)
      surveys_user.create_or_update_answer(text_answer_params, question)
    end

    it 'calls #create_or_update_text_answer when question_type is textarea' do
      question.textarea!
      expect(surveys_user).to receive(:create_or_update_text_answer)
      surveys_user.create_or_update_answer(text_answer_params, question)
    end

    it 'calls #delete_unchecked_choise_answer and #create_or_update_checkbox_answer when question_type is checkbox' do
      question.checkbox!
      questions_choise = create(:questions_choise, question_id: question.id)
      answer_params = { question_id: question.id, choise_ids: [questions_choise.id] }
      expect(surveys_user).to receive(:delete_unchecked_choise_answer)
      expect(surveys_user).to receive(:create_or_update_checkbox_answer)
      surveys_user.create_or_update_answer(answer_params, question)
    end

    it 'calls create_or_update_radio_answer when question_type is radio_button' do
      question.radio_button!
      questions_choise = create(:questions_choise, question_id: question.id)
      answer_params = { question_id: question.id, questions_choise_id: questions_choise.id }
      expect(surveys_user).to receive(:create_or_update_radio_answer)
      surveys_user.create_or_update_answer(answer_params, question)
    end
  end

  describe '#create_or_update_text_answer' do
    it 'create text_answer when it is not answered so far' do
      expect {
        surveys_user.create_or_update_text_answer(text_answer_params)
      }.to change(surveys_user.text_answers, :count).by(1)
      end
    it 'edit answer when it is answered once' do
      text_answer = create(:text_answer, question_id: question.id, surveys_user_id: surveys_user.id)
      surveys_user.create_or_update_text_answer(text_answer_params)
      text_answer.reload
      expect(text_answer.description).to eq('aaa')
    end
  end

  context 'question type is checkbox' do
    before do
      question.checkbox!
    end
    describe '#create_or_update_checkbox_answer' do
      let(:question_choises) { create_list(:questions_choise, 2, question_id: question.id) }
      let(:choise_ids) { question_choises.pluck(:id) }
      it 'create checkbox_answers when it is not answered so far' do
        answer_params = { question_id: question.id, choise_ids: [choise_ids[0], choise_ids[1]] }
        expect {
          surveys_user.create_or_update_checkbox_answer(answer_params)
        }.to change(question.choise_answers, :count).by(2)
      end
    end

    describe '#delete_unchecked_choise_answer' do
      let(:question_choises) { create_list(:questions_choise, 2, question_id: question.id) }
      let(:choise_ids) { question_choises.pluck(:id) }
      it 'delete choises if they are unchecked' do
        choise_answer = ChoiseAnswer.create(question_id: question.id, surveys_user_id: surveys_user.id, questions_choise_id: choise_ids[0])
        checked_ids = [choise_ids[0]]
        answer_params = { question_id: question.id, choise_ids: [choise_ids[1]] }
        expect {
          surveys_user.delete_unchecked_choise_answer(checked_ids, answer_params)
        }.to change(surveys_user.choise_answers, :count).by(-1)
      end
    end
  end

  describe 'create_or_update_radio_answer' do
    let(:question_choises) { create_list(:questions_choise, 2, question_id: question.id) }
    let(:choise_ids) { question_choises.pluck(:id) }
    before do
      question.radio_button!
    end
    it 'create choise_answer when it is not answered so far' do
      answer_params = { question_id: question.id, questions_choise_id: choise_ids[0] }
      expect {
        surveys_user.create_or_update_radio_answer(answer_params)
      }.to change(surveys_user.choise_answers, :count).by(1)
    end
    it 'edit answer when it is answered once' do
      choise_answer = ChoiseAnswer.create(question_id: question.id, surveys_user_id: surveys_user.id, questions_choise_id: choise_ids[0])
      answer_params = { question_id: question.id, questions_choise_id: choise_ids[1] }
      surveys_user.create_or_update_radio_answer(answer_params)
      choise_answer.reload
      expect(choise_answer.questions_choise_id).to eq(choise_ids[1])
    end
  end
end