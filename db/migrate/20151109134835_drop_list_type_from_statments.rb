class DropListTypeFromStatments < ActiveRecord::Migration
  def change
	  remove_column :statements, :list_type
  end
end
