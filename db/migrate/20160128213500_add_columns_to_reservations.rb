class AddColumnsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :starttime, :datetime
    add_column :reservations, :endtime, :datetime
    add_column :reservations, :recurring, :integer
  end
end
