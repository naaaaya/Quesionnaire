class AddQuestionTypeToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :question_type, :integer, defalut: 0
  end
end
