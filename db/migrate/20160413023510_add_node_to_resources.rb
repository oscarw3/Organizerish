class AddNodeToResources < ActiveRecord::Migration
  def change
    add_reference :resources, :node, index: true, foreign_key: true
  end
end
