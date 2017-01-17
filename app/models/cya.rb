class Cya < ActiveRecord::Base
	belongs_to :section
	scope :sorted, lambda { order("cyas.display_order")}
end
