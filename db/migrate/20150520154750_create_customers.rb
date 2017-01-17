class CreateCustomers < ActiveRecord::Migration
  def up
    create_table :customers do |t|
      t.string "name", :limit => 150
      t.binary "logo"
      t.string "tagline", :limit => 500
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :customers
  end
end
