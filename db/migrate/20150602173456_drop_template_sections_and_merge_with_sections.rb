class DropTemplateSectionsAndMergeWithSections < ActiveRecord::Migration
  
  def up
    drop_table :template_sections
    add_column :sections, :template_id, :integer
  end
  
  def down
    create_table :template_sections do |t|
      t.integer "template_id"
      t.integer "section_type_id"
      t.integer "display_order"
      t.timestamps null: false
    end
    add_index :template_sections, "template_id"
    add_index :template_sections, "section_type_id"
    remove_column :sections, :template_id
  end
  
end
