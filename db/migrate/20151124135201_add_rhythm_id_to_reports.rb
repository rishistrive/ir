class AddRhythmIdToReports < ActiveRecord::Migration
  def change
	  add_column :reports, :rhythm_id, :integer
  end
end
