class RemoveNumberFromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :number, :integer
  end
end
