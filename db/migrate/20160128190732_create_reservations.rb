class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :occupied
      t.references :resource, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
