class RemoveInspectorIdFromRhythms < ActiveRecord::Migration
  def up
    remove_column :rhythms, :inspector_id
  end
  
  def down
    add_column :rhythms, :inspector_id, :integer
  end
end
