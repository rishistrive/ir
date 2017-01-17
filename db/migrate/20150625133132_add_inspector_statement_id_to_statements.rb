class AddInspectorStatementIdToStatements < ActiveRecord::Migration
  def up
    add_column :statements, :inspector_statement_id, :integer
    add_index :statements, :inspector_statement_id
  end
  
  def down
    remove_column :statements, :inspector_statement_id
  end
end
