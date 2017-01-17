class AddLevelToSectionTypes < ActiveRecord::Migration
  def change
    add_column :section_types, :level, :integer
  end
end
