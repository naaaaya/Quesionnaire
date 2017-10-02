require 'rails_helper'

describe SurveysUser do
  let(:survey) { create(:survey) }
  let(:user) { create(:user) }
  let!(:surveys_user) { create(:surveys_user, survey_id: survey.id, user_id: user.id)}
  let!(:question) { create(:question, survey_id: survey.id) }
  let(:text_answer_params) { { question_id: question.id, description: 'aaa' } }
  let(:question_choises) { create_list(:questions_choise, 2, question_id: question.id) }
  let(:choise_ids) { question_choises.pluck(:id) }

  it { expect(surveys_user).to be_valid }

  describe '#create_or_update_answer' do
    it 'calls #create_or_update_text_answer when question_type is text_field' do
      question.text_field!
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
    it { expect {
      surveys_user.create_or_update_text_answer(text_answer_params)
    }.to change(surveys_user.text_answers, :count).by(1) }

    it 'update text_answer when it is answered' do
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
      it 'create checkbox_answers when it is not answered' do
        answer_params = { question_id: question.id, choise_ids: [choise_ids[0], choise_ids[1]] }
        expect {
          surveys_user.create_or_update_checkbox_answer(answer_params)
        }.to change(question.choise_answers, :count).by(2)
      end
    end

    describe '#delete_unchecked_choise_answer' do
      it 'delete choises if they are unchecked' do
        choise_answer = create(:choise_answer, question_id: question.id, surveys_user_id: surveys_user.id, questions_choise_id: choise_ids[0])
        checked_ids = [choise_ids[0]]
        answer_params = { question_id: question.id, choise_ids: [choise_ids[1]] }
        expect {
          surveys_user.delete_unchecked_choise_answer(checked_ids, answer_params)
        }.to change(surveys_user.choise_answers, :count).by(-1)
      end
    end
  end

  describe 'create_or_update_radio_answer' do
    before do
      question.radio_button!
    end
    it 'create choise_answer when it is not answered' do
      answer_params = { question_id: question.id, questions_choise_id: choise_ids[0] }
      expect {
        surveys_user.create_or_update_radio_answer(answer_params)
      }.to change(surveys_user.choise_answers, :count).by(1)
    end
    it 'update choise_answer when it is answered' do
      choise_answer = create(:choise_answer, question_id: question.id, surveys_user_id: surveys_user.id, questions_choise_id: choise_ids[0])
      answer_params = { question_id: question.id, questions_choise_id: choise_ids[1] }
      surveys_user.create_or_update_radio_answer(answer_params)
      choise_answer.reload
      expect(choise_answer.questions_choise_id).to eq(choise_ids[1])
    end
  end
end