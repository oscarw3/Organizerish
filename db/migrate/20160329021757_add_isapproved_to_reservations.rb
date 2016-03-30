class AddIsapprovedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :isapproved, :boolean
  end
end
