class Statement < ActiveRecord::Base
  
  belongs_to :section
  belongs_to :statement_type
  belongs_to :inspector_statement
  
  scope :sorted, lambda { order("statements.display_order")}
=begin  
  #commented b/c this removes the degree symbol
  def content=(val)
    # See String#encode
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    write_attribute(:content, val.encode(Encoding.find('ASCII'), encoding_options))
  end
=end
end
