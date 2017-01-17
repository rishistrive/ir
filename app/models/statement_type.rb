class StatementType < ActiveRecord::Base
  
  has_many :inspector_statements
  has_many :statements
  
end
