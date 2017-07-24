class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_reference :users, :company, index: true
    add_column :users, :chief_flag, :boolean
    add_column :users, :image, :text
  end
end
