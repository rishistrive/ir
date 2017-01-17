class AddInspectionTemplateIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :inspection_template_id, :integer
  end
end
