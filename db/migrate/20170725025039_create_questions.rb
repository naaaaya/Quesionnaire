class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :description
      t.integer :type, default: 0
      t.references :survey
      t.timestamps
    end
  end
end
