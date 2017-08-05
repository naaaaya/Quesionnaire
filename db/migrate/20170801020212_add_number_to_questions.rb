class AddNumberToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :number, :integer
  end
end
