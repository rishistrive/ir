class CreateStatements < ActiveRecord::Migration
  def up
    create_table :statements do |t|
      t.integer "section_id"
      t.integer "severity_id"
      t.integer "display_order"
      t.text "content"      
      t.timestamps null: false
    end
    add_index :statements, "section_id"
    add_index :statements, "severity_id"
  end
  
  def down
    drop_table :statements
  end
end
