class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :content
      t.integer :section_id
      t.integer :type_id
      t.boolean :completed
      t.integer :display_order

      t.timestamps null: false
    end
    add_index :to_dos, :section_id
    add_index :to_dos, :type_id
  end
end
