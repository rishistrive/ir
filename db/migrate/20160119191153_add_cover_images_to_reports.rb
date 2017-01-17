class AddCoverImagesToReports < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :reports, :cover_image
  end
end
