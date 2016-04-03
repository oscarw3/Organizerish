class AddSharingLimitToResources < ActiveRecord::Migration
  def change
    add_column :resources, :sharing_limit, :integer
  end
end
