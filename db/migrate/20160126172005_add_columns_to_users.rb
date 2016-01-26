class AddColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :firstname, :string
  	add_column :users, :lastname, :string
  	add_column :users, :role, :integer, default: 1
  end
end
