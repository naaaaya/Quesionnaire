class RemoveTypeFromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :type, :integer
  end
end
