class JoinReservationsUnapprovedResources < ActiveRecord::Migration
  def change
  	create_table :reservations_unapproved_resources do |t|
      t.references :resource, index: true
      t.references :reservation, index: true
      t.timestamps
    end
  end
end
