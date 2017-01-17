class CreateSeverities < ActiveRecord::Migration
  def up
    create_table :severities do |t|
      t.string "name"
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :severities    
  end
end
