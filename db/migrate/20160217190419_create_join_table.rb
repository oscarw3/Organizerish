class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :Groups, :Users do |t|
      # t.index [:group_id, :user_id]
      # t.index [:user_id, :group_id]
    end
  end
end
