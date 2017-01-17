class AddSelectedToAnswerValues < ActiveRecord::Migration
  def up
    add_column :answer_values, :selected, :boolean
  end
  
  def down
    remove_column :answer_values, :selected
  end
end
