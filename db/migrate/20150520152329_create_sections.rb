class CreateSections < ActiveRecord::Migration
  def up
    create_table :sections do |t|
      t.integer "report_id"
      t.integer "parent_section_id"
      t.integer "section_type_id"
      t.integer "display_order"
      t.timestamps null: false
    end
    add_index :sections, "report_id"
    add_index :sections, "parent_section_id"
    add_index :sections, "section_type_id"
  end
  
  def down    
    drop_table :sections
  end
end
