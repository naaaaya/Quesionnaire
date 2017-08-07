class CreateTextAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :text_answers do |t|
      t.text :description
      t.references :question
      t.references :surveys_user

      t.timestamps
    end
  end
end
