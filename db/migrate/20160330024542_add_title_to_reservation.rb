class AddTitleToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :title, :string
  end
end
