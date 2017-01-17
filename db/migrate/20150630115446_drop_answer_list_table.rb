class DropAnswerListTable < ActiveRecord::Migration
  def up
    drop_table :answer_lists
    remove_column :inspector_statements, :answer_list_id
    remove_column :statements, :answer_list_id
    remove_column :answer_values, :answer_list_id
    add_column :answer_values, :inspector_statement_id, :integer
    add_column :answer_values, :statement_id, :integer
    add_column :inspector_statements, :list_type, :string
    add_column :statements, :list_type, :string
    add_index :answer_values, :statement_id
    add_index :answer_values, :inspector_statement_id
  end
  
  def down
    create_table :answer_lists do |t|
      t.string "type", :null => false
      t.timestamps null: false
    end
    add_column :inspector_statements, :answer_list_id, :integer
    add_column :statements, :answer_list_id, :integer
    add_column :answer_values, :answer_list_id, :integer
    remove_column :answer_values, :inspector_statement_id
    remove_column :answer_values, :statement_id
    remove_column :inspector_statements, :list_type
    remove_column :statements, :list_type
  end
end
