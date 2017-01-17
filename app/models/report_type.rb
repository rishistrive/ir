class ReportType < ActiveRecord::Base
  
  has_many :reports
  has_many :inspection_templates
  
end
