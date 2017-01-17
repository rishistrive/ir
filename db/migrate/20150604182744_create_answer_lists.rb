class CreateAnswerLists < ActiveRecord::Migration
  def up
    create_table :answer_lists do |t|
      t.string "type", :null => false
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :answer_lists
  end
end
