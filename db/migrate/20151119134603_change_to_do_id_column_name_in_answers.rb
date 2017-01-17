class ChangeToDoIdColumnNameInAnswers < ActiveRecord::Migration
  def change
	  rename_column :answers, :todo_id, :to_do_id
  end
end
