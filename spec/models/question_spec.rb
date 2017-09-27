require 'rails_helper'

describe Question do
  let(:survey) { create(:survey) }
  let(:company) { create(:company) }
  let(:user) { create(:user, company_id: company.id) }
  it 'is valid with description' do
    question = build(:question, survey_id: survey.id)
    expect(question).to be_valid
  end
  it 'is invalid without description' do
    question = build(:question, description: nil, survey_id: survey.id)
    question.valid?
    expect(question.errors[:description]).to include("を入力してください")
  end

  describe '#is_answered?' do
    let(:question) { create(:question, survey_id: survey.id) }
    subject { question.is_answered?(user)}

    context 'survey is not answered' do
      it { is_expected.to be false }
    end

    context 'survey is answered' do
      let!(:surveys_user) { SurveysUser.create(survey_id: survey.id, user_id: user.id) }
      context 'return false if question is not answered' do
        it { is_expected.to be false }
      end

      context 'text question is answered' do
        let!(:text_answer) { create(:text_answer, surveys_user_id: surveys_user.id, question_id: question.id) }
        it { is_expected.to be true }
      end

      context 'choice question is answered' do
        let(:question) { create(:question, survey_id: survey.id, question_type: 2) }
        let!(:questions_choise) { create(:questions_choise, question_id: question.id) }
        let!(:choise_answer) { ChoiseAnswer.create(surveys_user_id: surveys_user.id, question_id: question.id,
                              questions_choise_id: questions_choise.id) }
        it { is_expected.to be true }
      end
    end
  end

  describe '#create_question' do
    let(:question) { build(:question, survey_id: survey.id, question_type: 2) }
    it 'create question' do
      question_params = { description: question.description, question_type: question.question_type }
      expect {
        Question.create_question(survey, question_params)
      }.to change(survey.questions, :count).by(1)
    end
    it 'create choices when params has choices' do
      question_params = { description: question.description, question_type: question.question_type, choises: [{ description: 'aaa' }, {description: 'bbb'}] }
      expect {
        Question.create_question(survey, question_params)
      }.to change(QuestionsChoise, :count).by(2)
    end
  end

  describe '#edit_question' do
    let(:question) { create(:question, survey_id: survey.id, question_type: 3) }
    it 'destroy choices when question_type is changed' do
      question_params = { id: question.id, description: 'aaa', question_type: 2 }
      questions_choise = create(:questions_choise, question_id: question.id)
      expect {
        question.edit_question(question_params)
        }.to change(question.questions_choises, :count).by(-1)
    end
    it 'edit choices when params has choices' do
      questions_choise = create(:questions_choise, question_id: question.id)
      question_params = { id: question.id, description: 'aaa', question_type: 2, choises: [{id: questions_choise.id, description: 'aaa'}] }
      question.edit_question(question_params)
      questions_choise.reload
      expect(questions_choise.description).to eq('aaa')
    end
    it 'create choices when params has new choices' do
      question_params = { id: question.id, description: 'aaa', question_type: 2, choises: [{description: 'aaa'}] }
      expect {
        question.edit_question(question_params)
      }.to change(question.questions_choises, :count).by(1)
    end

    it 'edit question' do
      question_params = { id: question.id, description: 'aaa', question_type: 2 }
      question.edit_question(question_params)
      question.reload
      expect(question.description).to eq('aaa')
      expect(question.question_type_before_type_cast).to eq(2)
    end
  end

  describe '#create_choise' do
    it 'create choise' do
      choise_params = { description: 'aaa' }
      question = create(:question, survey_id: survey.id, question_type: 3)
      expect {
        question.create_choise(choise_params)
        }.to change(question.questions_choises, :count).by(1)
    end
  end

  describe '#overall_choise_answers_for_chart' do
    it 'return data for chart' do
      question = create(:question, survey_id: survey.id, question_type: 3)
      users = create_list(:user, 2, company_id: company.id)
      questions_choises = create_list(:questions_choise, 3, question_id: question.id)
      ChoiseAnswer.create(surveys_user_id: users[0].id, question_id: question.id, questions_choise_id: questions_choises[0].id)
      ChoiseAnswer.create(surveys_user_id: users[1].id, question_id: question.id, questions_choise_id: questions_choises[0].id)
      ChoiseAnswer.create(surveys_user_id: users[0].id, question_id: question.id, questions_choise_id: questions_choises[1].id)
      ChoiseAnswer.create(surveys_user_id: users[1].id, question_id: question.id, questions_choise_id: questions_choises[2].id)
      overall_choise_answers_for_chart = { questions_choises[0].description.to_s => 2, questions_choises[1].description.to_s => 1, questions_choises[2].description.to_s => 1 }
      expect(question.overall_choise_answers_for_chart).to eq(overall_choise_answers_for_chart)
    end
  end

end