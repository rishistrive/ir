class DropListTypeFromInspectorStatments < ActiveRecord::Migration
  def change
	  remove_column :inspector_statements, :list_type
  end
end
