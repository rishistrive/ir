class AddDisplayOrderToInspectorStatements < ActiveRecord::Migration
  def change
    add_column :inspector_statements, :display_order, :integer
  end
end
