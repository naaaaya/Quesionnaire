class SurveysCompany < ApplicationRecord
  belongs_to :company
  belongs_to :survey
end
