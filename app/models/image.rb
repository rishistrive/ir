class Image < ActiveRecord::Base
  
  has_attached_file :image, styles: {medium: "600x600#", small: "300x300#", thumb: "100x100#"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  belongs_to :section
  
  def image_url
    image.url
  end
  
  def image_thumbnail_url
    image.url(:thumb)
  end
  
=begin  
  #commented b/c this removes the degree symbol
  def caption=(val)
    # See String#encode
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    write_attribute(:caption, val.encode(Encoding.find('ASCII'), encoding_options))
  end
=end
end
