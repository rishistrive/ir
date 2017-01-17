class AddStatementTypeIdtoStatements < ActiveRecord::Migration
  def up
    add_column :statements, :statement_type_id, :integer
    add_index :statements, :statement_type_id
  end
  
  def down
    remove_column :statements, :statement_type_id
  end
end
