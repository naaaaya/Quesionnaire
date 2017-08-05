class CreateQuestionsChoises < ActiveRecord::Migration[5.0]
  def change
    create_table :questions_choises do |t|
      t.string :description
      t.references :question

      t.timestamps
    end
  end
end
