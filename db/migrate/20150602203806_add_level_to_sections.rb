class AddLevelToSections < ActiveRecord::Migration
  def up
    add_column :sections, :level, :integer
  end
  
  def down
    remove_column :sections, :level
  end
end
