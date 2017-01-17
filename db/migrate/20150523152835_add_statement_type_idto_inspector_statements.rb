class AddStatementTypeIdtoInspectorStatements < ActiveRecord::Migration
  def up
    add_column :inspector_statements, :statement_type_id, :integer
    add_index :inspector_statements, :statement_type_id
  end
  
  def down
    remove_column :inspector_statements, :statement_type_id
  end
end
