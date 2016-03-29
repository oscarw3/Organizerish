class AddIsrestrictedToResources < ActiveRecord::Migration
  def change
    add_column :resources, :isrestricted, :boolean
  end
end
