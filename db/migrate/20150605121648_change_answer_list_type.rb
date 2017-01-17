class ChangeAnswerListType < ActiveRecord::Migration
  def up
    rename_column :answer_lists, :type, :list_type
  end
  def down 
    rename_column :answer_lists, :list_type, :type
  end
end
