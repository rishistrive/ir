class AddInspectorIdToAnswerList < ActiveRecord::Migration
  def up
    add_column :answer_lists, :inspector_id, :integer
    add_index :answer_lists, :inspector_id
  end
  
  def down
    remove_column :answer_lists, :inspector_id
  end
end
