class CreateStatementTypes < ActiveRecord::Migration
  def up
    create_table :statement_types do |t|
      t.string :name
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :statement_types
  end
end
