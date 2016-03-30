class AddDescriptionToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :description, :string
  end
end
