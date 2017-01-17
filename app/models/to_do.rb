class ToDo < ActiveRecord::Base
	belongs_to :section
	has_many :answers, -> {order(:display_order)}, :dependent => :destroy
	belongs_to :to_do_type

	scope :sorted, lambda { order("to_dos.display_order")}
end
