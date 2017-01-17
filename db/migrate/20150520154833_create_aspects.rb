class CreateAspects < ActiveRecord::Migration
  def up
    create_table :aspects do |t|
      t.integer "section_id"
      t.integer "display_order"
      t.text "content"
      t.timestamps null: false
    end
    add_index :aspects, "section_id"
  end
  
  def down
    drop_table :aspects
  end
end
