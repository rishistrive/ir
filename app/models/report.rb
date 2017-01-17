class Report < ActiveRecord::Base

  belongs_to :inspector
  belongs_to :report_type
  belongs_to :rhythm
  belongs_to :inspection_template
  has_many :sections, :dependent => :destroy

  has_attached_file :cover_image, styles: {medium: "600x600#", small: "300x300#", thumb: "100x100#"}
  validates_attachment_content_type :cover_image, :content_type => /\Aimage\/.*\Z/
  
  scope :sorted, lambda { order("reports.inspection_datetime DESC")}
  
  def address_single_line
    # TODO: clean up empty address lines 2 - 4 and handle nil values
    address_line_1.to_s + ' ' + address_line_2.to_s + ' ' + address_line_3.to_s + ' ' + address_line_4.to_s + ' ' + city.to_s + ', ' + state.to_s + '  ' + zip.to_s
  end

  def address_first_line
    address_line_1.to_s + ' ' + address_line_2.to_s + ' ' + address_line_3.to_s + ' ' + address_line_4.to_s
  end

  def address_second_line
    city.to_s + ', ' + state.to_s + '  ' + zip.to_s
  end

  def as_json(options = {})
    super.merge(inspection_datetime: inspection_datetime.strftime('%B %d, %Y'))
  end

  def cover_image_url
    cover_image.url
  end
  
  def cover_image_thumbnail_url
    cover_image.url(:thumb)
  end
  
end
