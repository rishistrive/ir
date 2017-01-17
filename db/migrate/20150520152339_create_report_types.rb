class CreateReportTypes < ActiveRecord::Migration
  def up
    create_table :report_types do |t|
      t.string "type_name"
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :report_types
  end
end
