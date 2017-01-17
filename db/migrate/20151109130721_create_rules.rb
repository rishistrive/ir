class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :answer_id
      t.integer :inspector_statement_id

      t.timestamps null: false
    end
    add_index :rules, :answer_id
  end
end
