class CreateJoinTableGroupPermission < ActiveRecord::Migration
  def change
    create_join_table :groups, :permissions do |t|
      # t.index [:group_id, :permission_id]
      # t.index [:permission_id, :group_id]
    end
  end
end
