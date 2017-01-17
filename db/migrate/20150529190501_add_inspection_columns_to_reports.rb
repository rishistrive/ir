class AddInspectionColumnsToReports < ActiveRecord::Migration
  def up
    add_column "reports", "address_line_1", :string
    add_column "reports", "address_line_2", :string
    add_column "reports", "address_line_3", :string
    add_column "reports", "address_line_4", :string
    add_column "reports", "city", :string
    add_column "reports", "state", :string
    add_column "reports", "zip", :string    
  end
  
  def down
    remove_column "reports", "address_line_1"
    remove_column "reports", "address_line_2"
    remove_column "reports", "address_line_3"
    remove_column "reports", "address_line_4"
    remove_column "reports", "city"
    remove_column "reports", "state"
    remove_column "reports", "zip"    
  end
end
