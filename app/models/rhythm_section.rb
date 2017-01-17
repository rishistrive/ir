class RhythmSection < ActiveRecord::Base

  belongs_to :rhythm
  belongs_to :section_type

  default_scope { order("rhythm_sections.completion_order")}
end
