class Category < ApplicationRecord
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category', optional: true

  validates :name, presence: true, uniqueness: true
  validates :category_type, inclusion: { in: [ Product.to_s, Service.to_s ] }

end