class CreateAnswerValues < ActiveRecord::Migration
  def up
    create_table :answer_values do |t|
      t.integer :answer_list_id, :null => false
      t.string :value
      t.integer :display_order
      t.timestamps null: false
    end
    add_index :answer_values, "answer_list_id"
  end
  def down
    drop_table :answer_values    
  end
end
