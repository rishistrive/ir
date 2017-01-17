class RelateRhythmsWithTemplatesInsteadOfReportTypes < ActiveRecord::Migration
  def up
    remove_column :rhythms, :report_type_id
    add_column :rhythms, :template_id, :integer
    add_index :rhythms, "template_id"
  end
  
  def down
    add_column :rhythms, :report_type_id, :integer
    add_index :rhythms, "report_type_id"
  end
end
