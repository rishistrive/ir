class CreateClients < ActiveRecord::Migration
  def up
    create_table :clients do |t|
      t.integer "customer_id"
      t.string "name"
      t.string "email"
      t.string "primary_phone"
      t.string "secondary_phone"
      t.timestamps null: false
    end
    add_index :clients, "customer_id"
  end
  
  def down
    drop_table :clients
  end
end
