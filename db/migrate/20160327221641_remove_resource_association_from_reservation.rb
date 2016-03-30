class RemoveResourceAssociationFromReservation < ActiveRecord::Migration
  def change
  	remove_column :reservations, :resource_id
  end
end
