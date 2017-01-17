class AddInspectorIdToSectionTypes < ActiveRecord::Migration
  def up
    add_column :section_types, :inspector_id, :integer
    add_index :section_types, "inspector_id"
  end
  
  def down
    remove_column :section_types, :inspector_id
  end
end
