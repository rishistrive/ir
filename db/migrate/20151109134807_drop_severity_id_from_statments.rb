class DropSeverityIdFromStatments < ActiveRecord::Migration
  def change
	  remove_column :statements, :severity_id
  end
end
