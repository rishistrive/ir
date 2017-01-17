class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer "section_id"
      t.integer "display_order"
      t.binary "image"
      t.string "caption", :limit => 100
      t.timestamps null: false
    end
    add_index :images, "section_id"
  end
  
  def down
    drop_table :images
  end
end
