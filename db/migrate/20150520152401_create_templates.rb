class CreateTemplates < ActiveRecord::Migration
  def up
    create_table :templates do |t|
      t.integer "inspector_id"
      t.integer "report_type_id"
      t.string "name"
      t.timestamps null: false
    end
    add_index :templates, "inspector_id"
    add_index :templates, "report_type_id"
  end
  
  def down
    drop_table :templates
  end
end
