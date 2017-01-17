class CreateRhythms < ActiveRecord::Migration
  def up
    create_table :rhythms do |t|
      t.integer "inspector_id"
      t.integer "report_type_id"
      t.string "name"
      t.timestamps null: false
    end
    add_index :rhythms, "inspector_id"
    add_index :rhythms, "report_type_id"
  end
  def down
    drop_table :rhythms
  end
end
