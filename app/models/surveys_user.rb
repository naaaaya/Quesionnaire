class SurveysUser < ApplicationRecord
  has_many :text_answers
  has_many :choise_answers
end
