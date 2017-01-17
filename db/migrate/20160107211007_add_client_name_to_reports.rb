class AddClientNameToReports < ActiveRecord::Migration
  def change
    add_column :reports, :client_name, :string
  end
end
