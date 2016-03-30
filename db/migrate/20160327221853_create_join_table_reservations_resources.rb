class CreateJoinTableReservationsResources < ActiveRecord::Migration
  def change
    create_join_table :reservations, :resources do |t|
      # t.index [:reservation_id, :resource_id]
      # t.index [:resource_id, :reservation_id]
    end
  end
end
