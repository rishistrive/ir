class CreateInspectors < ActiveRecord::Migration
  def up
    create_table :inspectors do |t|
      t.integer "customer_id", :null => false
      t.string "email", :limit => 100, :default => "", :null => false
      t.string "first_name", :limit => 25
      t.string "last_name", :limit => 50
      t.timestamps null: false
    end
    add_index :inspectors, "customer_id"
  end
  
  def down
    drop_table :inspectors
  end
      
end
