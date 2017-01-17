class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :todo_id
      t.string :content
      t.integer :display_order
      t.boolean :selected

      t.timestamps null: false
    end
  end
end
