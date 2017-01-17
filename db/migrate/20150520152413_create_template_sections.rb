class CreateTemplateSections < ActiveRecord::Migration
  def up
    create_table :template_sections do |t|
      t.integer "template_id"
      t.integer "section_type_id"
      t.integer "display_order"
      t.timestamps null: false
    end
    add_index :template_sections, "template_id"
    add_index :template_sections, "section_type_id"
  end
  
  def down
    drop_table :template_sections    
  end
end
