class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :description
      t.integer :status, defalut: 0
      t.timestamps
    end
  end
end
