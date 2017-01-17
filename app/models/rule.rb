class Rule < ActiveRecord::Base
	belongs_to :answer
  belongs_to :inspector_statement
  #has_one :inspector_statement
end
