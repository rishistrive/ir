class CreateSectionTypes < ActiveRecord::Migration
  def up
    create_table :section_types do |t|
      t.string "name", :limit => 50
      t.string "title", :limit => 100
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :section_types
  end
end
