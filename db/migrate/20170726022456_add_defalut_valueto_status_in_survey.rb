class AddDefalutValuetoStatusInSurvey < ActiveRecord::Migration[5.0]
  def change
    change_column :surveys, :status, :integer, :default => 0
  end
end
