class AddKeywordToInspectorStatements < ActiveRecord::Migration
  def up
    add_column "inspector_statements", "keyword", :string
  end
  
  def down
    remove_column "inspector_statements", "keyword"
  end
end
