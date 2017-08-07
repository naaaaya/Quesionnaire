class CreateChoiseAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :choise_answers do |t|
      t.references :question
      t.references :questions_choise
      t.references :surveys_user

      t.timestamps
    end
  end
end
