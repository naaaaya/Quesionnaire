class SurveysUser < ApplicationRecord
  has_many :text_answers, dependent: :destroy
  has_many :choise_answers, dependent: :destroy
  belongs_to :survey
  belongs_to :user
  validates :survey_id, uniqueness: {scope: :user_id}
  scope :answered, -> { where(answered_flag: true) }
  scope :drafts, -> { where(answered_flag: false) }


  def create_or_update_text_answer(answer_param)
    text_answer = text_answers.where(question_id: answer_param[:question_id]).first_or_initialize
    text_answer.description = answer_param[:description]
    text_answer.save!
  end

  def create_or_update_checkbox_answer(answer_param)
    if answer_param[:choise_ids]
      answer_param[:choise_ids].each do |choise_id|
        choise_answer = choise_answers.where(question_id: answer_param[:question_id], questions_choise_id: choise_id).first_or_initialize
        choise_answer.save!
      end
    end
  end

  def delete_unchecked_choise_answer(checked_ids, answer_param)
    checked_ids.each do |checked_id|
      unless answer_param[:choise_ids].try(:include?, checked_id.to_s)
        delete_choise_answer = choise_answers.find_by(questions_choise_id: checked_id)
      end
      delete_choise_answer.destroy! if delete_choise_answer.present?
    end
  end

  def create_or_update_radio_answer(answer_param)
    if answer_param[:questions_choise_id]
      choise_answer = choise_answers.where(question_id: answer_param[:question_id]).first_or_initialize
      choise_answer.questions_choise_id = answer_param[:questions_choise_id]
      choise_answer.save!
    end
  end




end
