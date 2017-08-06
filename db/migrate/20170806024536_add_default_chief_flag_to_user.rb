class AddDefaultChiefFlagToUser < ActiveRecord::Migration[5.0]
  change_column :users, :chief_flag, :boolean, default: false
  def change
  end
end
