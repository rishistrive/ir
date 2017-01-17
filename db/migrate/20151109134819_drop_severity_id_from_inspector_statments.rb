class DropSeverityIdFromInspectorStatments < ActiveRecord::Migration
  def change
	  remove_column :inspector_statements, :severity_id
  end
end
