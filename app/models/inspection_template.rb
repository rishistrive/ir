class InspectionTemplate < ActiveRecord::Base

  belongs_to :inspector
  belongs_to :report_type
  has_many :sections
  has_many :rhythms
  has_many :reports

  def getTemplateNameWithTypeName
	  name.to_s + " - " + report_type.name.to_s 
  end
end
