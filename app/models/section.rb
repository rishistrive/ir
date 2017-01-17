class Section < ActiveRecord::Base

  belongs_to :report
  belongs_to :section_type
  has_many :statements, -> {order(:display_order)}, :dependent => :destroy
  has_many :images, -> {order(:display_order)}, :dependent => :destroy
  has_many :subsections, class_name: "Section", foreign_key: "parent_section_id"
  has_many :to_dos, -> {order(:display_order)}, :dependent => :destroy
  has_many :cyas, -> {order(:display_order)}, :dependent => :destroy
  belongs_to :parent_section, class_name: "Section"
  
  scope :sorted, lambda { order("sections.display_order")}

end
