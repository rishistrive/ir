class Inspector < ActiveRecord::Base
  
  has_many :inspector_statements, -> {order(:display_order)}
  has_many :inspection_templates
  has_many :reports
  has_many :section_types
  has_many :clients
  
  has_secure_password
  
end
