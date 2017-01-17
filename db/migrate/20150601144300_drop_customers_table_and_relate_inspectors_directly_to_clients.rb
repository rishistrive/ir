class DropCustomersTableAndRelateInspectorsDirectlyToClients < ActiveRecord::Migration
  
  def up
    drop_table :customers
    add_column :inspectors, :company_name, :string, {limit: 150}
    add_column :inspectors, :logo, :binary
    add_column :inspectors, :tagline, :string, {limit: 500}
    remove_column :clients, :customer_id
    remove_column :inspectors, :customer_id
    add_column :clients, :inspector_id, :integer
    add_index :clients, "inspector_id"
  end
  
  def down
    create_table :customers do |t|
      t.string "name", :limit => 150
      t.binary "logo"
      t.string "tagline", :limit => 500
      t.timestamps null: false
    end
    add_column :clients, :customer_id, :integer
    add_column :inspectors, :customer_id, :integer
    remove_column :inspectors, :company_name
    remove_column :inspectors, :logo
    remove_column :inspectors, :tagline
    remove_column :clients, :inspector_id
    add_index :inspectors, "customer_id"
    add_index :clients, "customer_id"
  end
end
