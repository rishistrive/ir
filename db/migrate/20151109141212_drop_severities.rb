class DropSeverities < ActiveRecord::Migration
  def up
    drop_table :severities    
  end

  def down
    create_table :severities do |t|
      t.string "name"
      t.timestamps null: false
    end
  end
end
