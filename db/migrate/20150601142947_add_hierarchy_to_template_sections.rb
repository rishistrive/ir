class AddHierarchyToTemplateSections < ActiveRecord::Migration
  def up
    add_column :template_sections, :parent_section_id, :integer
    add_index :template_sections, "parent_section_id"
  end
  def down
    remove_column :Template_sections, :parent_section_id
  end
end
