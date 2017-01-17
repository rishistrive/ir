class SectionType < ActiveRecord::Base

  has_many :inspector_statements, -> {order(:display_order)}
  has_many :sections
  belongs_to :inspector


  def get_matching_section_type_id(section_type_id, other_inspector_id)
    @sectionType = SectionType.find(section_type_id)
    @matchingSectionType = SectionType.where(inspector_id: other_inspector_id, name: @sectionType.name, level: @sectionType.level, title: @sectionType.title).take
    return @matchingSectionType.id
  end

end
