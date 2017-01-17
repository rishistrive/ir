class CreateCyas < ActiveRecord::Migration
  def change
    create_table :cyas do |t|
      t.string :content
      t.integer :section_id
      t.boolean :completed
      t.integer :display_order

      t.timestamps null: false
    end
    add_index :cyas, :section_id
  end
end
