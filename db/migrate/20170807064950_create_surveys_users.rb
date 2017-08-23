class CreateSurveysUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys_users do |t|
      t.references :survey
      t.references :user
      t.boolean :answered_flag, default: false
      t.timestamps
    end
  end
end
