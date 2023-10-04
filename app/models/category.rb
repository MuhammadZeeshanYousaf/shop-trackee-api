class Category < ApplicationRecord
  include NameSearchable
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category', optional: true

  validates :name, presence: true, uniqueness: true
  validates :category_type, inclusion: { in: [ Product.to_s, Service.to_s ] }

  default_scope { where("name <> NULL OR name <> ''") }
  scope :product_type, -> { where category_type: Product.to_s }
  scope :service_type, -> { where category_type: Service.to_s }
  
end
