class AddOverviewAndOverviewSummaryAndScopeToReports < ActiveRecord::Migration
  def change
    add_column :reports, :scope, :string
    add_column :reports, :overview_summary, :string
    add_column :reports, :overview, :string
  end
end
