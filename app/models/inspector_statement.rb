class InspectorStatement < ActiveRecord::Base
  
  belongs_to :inspector
  belongs_to :section_type
  belongs_to :statement_type
  has_many :statements
  has_many :rules
  has_many :answers, through: :rules
  
  scope :sorted, lambda { order("inspector_statements.display_order")}
 # accepts_nested_attributes_for :answer_values
  
  def get_matching_inspector_statement_id(other_inspector_id)
    matchingInspectorStatement = InspectorStatement.where(inspector_id: other_inspector_id, statement_type_id: statement_type_id, content: content, keyword: keyword).take
    if matchingInspectorStatement.nil?
      return nil
    else
      return matchingInspectorStatement.id
    end
  end

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
=begin  
  #commented b/c this removes the degree symbol
  def keyword=(val)
    # See String#encode
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    write_attribute(:keyword, val.encode(Encoding.find('ASCII'), encoding_options))
  end
=end
end
