class CreateRhythmSections < ActiveRecord::Migration
  def up
    create_table :rhythm_sections do |t|
      t.integer "section_type_id"
      t.integer "rhythm_id"
      t.integer "completion_order"
      t.timestamps null: false
    end
    add_index :rhythm_sections, "section_type_id"
    add_index :rhythm_sections, "rhythm_id"
  end
  
  def down
    drop_table :rhythm_sections
  end
end
