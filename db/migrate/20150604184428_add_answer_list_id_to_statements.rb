class AddAnswerListIdToStatements < ActiveRecord::Migration
  def up
    add_column :statements, :answer_list_id, :integer
    add_index :statements, :answer_list_id
  end
  
  def down
    remove_column :statements, :answer_list_id
  end
end
