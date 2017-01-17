class ChangeToDosTypeIdColumnName < ActiveRecord::Migration
  def change
    rename_column :to_dos, :type_id, :to_do_type_id
  end
end
