class CreateInspectorStatements < ActiveRecord::Migration
  def up
    create_table :inspector_statements do |t|
      t.integer "inspector_id"
      t.integer "severity_id"
      t.integer "section_type_id"
      t.text "content"
      t.timestamps null: false
    end
    add_index :inspector_statements, "inspector_id"
    add_index :inspector_statements, "severity_id"
    add_index :inspector_statements, "section_type_id"
  end
  
  def down
    drop_table :inspector_statements
  end
end
