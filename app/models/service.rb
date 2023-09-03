class Service < ApplicationRecord
  belongs_to :category
  has_many_attached :images

  enum :charge_by, { hour: 0, day: 1, work: 2 }
  validates :name, :rate, :charge_by, presence: true
end
