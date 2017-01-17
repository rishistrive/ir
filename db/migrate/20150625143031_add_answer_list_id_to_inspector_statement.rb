class AddAnswerListIdToInspectorStatement < ActiveRecord::Migration
  def up
    add_column :inspector_statements, :answer_list_id, :integer
    add_index :inspector_statements, :answer_list_id
  end
  
  def down
    remove_column :inspector_statements, :answer_list_id
  end
end
