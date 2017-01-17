class DropSelectedAnswers < ActiveRecord::Migration
  def up
    drop_table :selected_answers
  end

  def down
    create_table :selected_answers do |t|
      t.integer :statement_id
      t.integer :answer_value_id

      t.timestamps null: false
    end
    add_index :selected_answers, :statement_id
  end
end
