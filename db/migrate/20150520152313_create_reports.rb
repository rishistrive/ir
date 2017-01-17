class CreateReports < ActiveRecord::Migration
  def up
    create_table :reports do |t|
      t.integer "inspector_id", :null => false
      t.integer "report_type_id", :null  => false
      t.datetime "inspection_datetime"
      t.timestamps null: false
    end
    add_index :reports, "inspector_id"
    add_index :reports, "report_type_id"
  end
  
  def down
    drop_table :reports
  end
  
end
