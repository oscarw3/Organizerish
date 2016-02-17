class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :resourcemanagement
      t.integer :reservationmanagement
      t.integer :usermanagement

      t.timestamps null: false
    end
  end
end
