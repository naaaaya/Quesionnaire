require 'rails_helper'

describe QuestionsChoise do
  describe '#edit_choise' do
    it 'edit choise' do
      survey = create(:survey)
      question = create(:question, survey_id: survey.id)
      questions_choise = create(:questions_choise, question_id: question.id)
      choise_params = {id: questions_choise.id, description: 'aaa'}
      questions_choise.edit_choise(choise_params)
      questions_choise.reload
      expect(questions_choise.description).to eq('aaa')
    end
  end
end