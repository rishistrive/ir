class Rhythm < ActiveRecord::Base

  belongs_to :inspection_template
  has_many :rhythm_sections
  has_many :reports

end
