class AddDetailsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :inspected, :boolean
    add_column :sections, :not_inspected, :boolean
    add_column :sections, :not_present, :boolean
    add_column :sections, :deficient, :boolean
  end
end
