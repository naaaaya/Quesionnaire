require 'rails_helper'

describe Question do
  let(:survey) { create(:survey) }
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
    let(:company) { create(:company) }
    let(:user) { create(:user, company_id: company.id) }
    let(:question) { create(:question, survey_id: survey.id) }
    it 'return false if survey is not answered' do
      expect(question.is_answered?(user)).to be false
    end
    it 'return false if question is not answered' do
      question = create(:question, survey_id: survey.id)
      surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id)
      expect(question.is_answered?(user)).to be false
    end
    it 'return true if text question is answered' do
      surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id)
      text_answer = create(:text_answer, surveys_user_id: surveys_user.id, question_id: question.id)
      expect(question.is_answered?(user)).to be true
    end
    it 'return true if choice question is answered' do
      question = create(:question, survey_id: survey.id, question_type: 2)
      surveys_user = SurveysUser.create(survey_id: survey.id, user_id: user.id)
      questions_choise = create(:questions_choise, question_id: question.id)
      choise_answer = ChoiseAnswer.create(surveys_user_id: surveys_user.id, question_id: question.id, questions_choise_id: questions_choise.id)
      expect(question.is_answered?(user)).to be true
    end
  end

  describe '#create_question' do
    let(:company) { create(:company) }
    let(:user) { create(:user, company_id: company.id) }
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
    let(:company) { create(:company) }
    let(:user) { create(:user, company_id: company.id) }
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

end