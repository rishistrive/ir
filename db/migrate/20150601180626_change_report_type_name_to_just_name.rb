class ChangeReportTypeNameToJustName < ActiveRecord::Migration
  def change
    rename_column :report_types, :type_name, :name
  end
end
