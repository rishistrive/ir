class ChangeTemplatesTableNameToInspectionTemplates < ActiveRecord::Migration
  def up
	  rename_table :templates, :inspection_templates
	  rename_column :rhythms, :template_id, :inspection_template_id
	  rename_column :sections, :template_id, :inspection_template_id
  end
  def down
	  rename_table :inspection_templates, :templates 
	  rename_column :rhythms, :inspection_template_id, :template_id
	  rename_column :sections, :inspection_template_id, :template_id
  end
end
