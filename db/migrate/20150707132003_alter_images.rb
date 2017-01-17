class AlterImages < ActiveRecord::Migration
  def up
    change_column :images, :image, :string
  end
  
  def down
    change_column :images, :image, :binary    
  end
end
