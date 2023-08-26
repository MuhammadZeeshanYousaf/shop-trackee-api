class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true


  has_many :users

end
