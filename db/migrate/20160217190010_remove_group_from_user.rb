class RemoveGroupFromUser < ActiveRecord::Migration
  def change
  	remove_reference :users, :group
  end
end
