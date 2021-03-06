require 'rails_helper'

describe Question do
  let(:survey) { create(:survey) }
  let(:user) { create(:user) }
  let(:question) { create(:question, survey_id: survey.id, question_type: 0) }
  let!(:questions_choise) { create(:questions_choise, question_id: question.id) }



  describe '#validate' do
    it { expect(build(:question, survey_id: survey.id)).to be_valid }

    it 'is invalid without description' do
      question = build(:question, description: nil, survey_id: survey.id)
      question.valid?
      expect(question.errors[:description]).to include("を入力してください")
    end
  end

  describe '#is_answered?' do
    subject { question.is_answered?(user)}

    context 'survey is not answered' do
      it { is_expected.to be false }
    end

    context 'survey is answered' do
      let!(:surveys_user) { create(:surveys_user, survey_id: survey.id, user_id: user.id) }
      context 'when question is not answered' do
        it { is_expected.to be false }
      end

      context 'text question is answered' do
        let!(:text_answer) { create(:text_answer, surveys_user_id: surveys_user.id, question_id: question.id) }
        it { is_expected.to be true }
      end

      context 'choice question is answered' do
        let!(:choise_answer) { create(:choise_answer, surveys_user_id: surveys_user.id, question_id: question.id,
          questions_choise_id: questions_choise.id) }
        before do
          question.checkbox!
        end
        it { is_expected.to be true }
      end
    end
  end

  describe '#create_question' do
    before do
      question.checkbox!
    end
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

  context 'question_type is radio_button' do
    before do
      question.checkbox!
    end
    describe '#edit_question' do
      let!(:questions_choise) { create(:questions_choise, question_id: question.id) }

      it 'destroy choices when question_type is changed' do
        question_params = { id: question.id, description: 'aaa', question_type: 3 }
        expect {
          question.edit_question(question_params)
        }.to change(question.questions_choises, :count).by(-1)
      end

      it 'edit choices when params has choices' do
        question_params = { id: question.id, description: 'aaa', question_type: 2, choises: [{id: questions_choise.id, description: 'aaa'}] }
        question.edit_question(question_params)
        questions_choise.reload
        expect(questions_choise.description).to eq('aaa')
      end

      it 'create choices when params has new choices' do
        question.checkbox!
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
        expect {
          question.create_choise(choise_params)
        }.to change(question.questions_choises, :count).by(1)
      end
    end

    describe '#overall_choise_answers_for_chart' do
      let!(:surveys_user) { create(:surveys_user, survey_id: survey.id, user_id: user.id) }
      it 'return data for chart' do
        users = create_list(:user, 2)
        surveys_users = []
        users.each_with_index do |user, index|
          surveys_users << create(:surveys_user, survey_id: survey.id, user_id: users[index].id, answered_flag: true)
        end
        questions_choises = create_list(:questions_choise, 3, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[0].id, surveys_user_id: surveys_users[0].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[0].id, surveys_user_id: surveys_users[1].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[1].id, surveys_user_id: surveys_users[0].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[2].id,surveys_user_id: surveys_users[1].id, question_id: question.id)
        overall_choise_answers_for_chart = { questions_choises[0].description.to_s => 2, questions_choises[1].description.to_s => 1, questions_choises[2].description.to_s => 1 }
        expect(question.overall_choise_answers_for_chart).to eq(overall_choise_answers_for_chart)
      end
    end

    describe '#company_choise_answers_for_chart' do
      it 'return data for chart' do
        company = create(:company)
        users = [user, create(:user, company_id: company.id)]
        surveys_users = [create(:surveys_user, survey_id: survey.id, user_id: users[0].id, answered_flag: true),
                          survey.surveys_users.create(user_id: users[1].id, answered_flag: true)]
        questions_choises = create_list(:questions_choise, 3, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[0].id, surveys_user_id: surveys_users[0].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[0].id, surveys_user_id: surveys_users[1].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[1].id, surveys_user_id: surveys_users[0].id, question_id: question.id)
        create(:choise_answer, questions_choise_id: questions_choises[2].id,surveys_user_id: surveys_users[1].id, question_id: question.id) 
        company_choise_answers_for_chart = { questions_choises[0].description.to_s => 1, questions_choises[2].description.to_s => 1 }
        expect(question.company_choise_answers_for_chart(company)).to eq(company_choise_answers_for_chart)
      end
    end
  end
end