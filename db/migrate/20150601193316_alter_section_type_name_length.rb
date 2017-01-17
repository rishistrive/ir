class AlterSectionTypeNameLength < ActiveRecord::Migration
  def up
    change_column :section_types, :name, :string, {:length => 100}
  end
  
  def down
    change_column :section_types, :name, :string, {:length => 50}    
  end
end
