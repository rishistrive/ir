class AddLicenseNumberAndSponseringInspectorToInspectors < ActiveRecord::Migration
  def change
    add_column :inspectors, :license_number, :string
    add_column :inspectors, :sponsor_name, :string
    add_column :inspectors, :sponsor_license_number, :string
  end
end
