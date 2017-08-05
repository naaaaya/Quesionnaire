class CreateSurveysCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys_companies do |t|
      t.references :survey
      t.references :company

      t.timestamps
    end
  end
end
