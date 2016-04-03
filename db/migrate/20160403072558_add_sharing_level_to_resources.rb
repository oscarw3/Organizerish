class AddSharingLevelToResources < ActiveRecord::Migration
  def change
    add_column :resources, :sharing_level, :integer
  end
end
