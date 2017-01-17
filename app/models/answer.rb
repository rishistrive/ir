class Answer < ActiveRecord::Base
	belongs_to :to_do
	has_many :rules, :dependent => :destroy
  has_many :inspector_statements, through: :rules
  
  scope :sorted, lambda { order("answers.display_order")}

end
