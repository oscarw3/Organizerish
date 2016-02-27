class Removeforeignkeyfrompermissions < ActiveRecord::Migration
  def change
  	remove_reference :permissions, :group
  end
end
