class Category < ApplicationRecord
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category', optional: true

  validates :name, presence: true, uniqueness: true
  validates :category_type, inclusion: { in: [ Product.to_s, Service.to_s ] }

  scope :find_all_like, ->(search_terms) {
    # Create an empty array to store individual search conditions
    search_conditions = []

    # Iterate through each search term and build search conditions
    search_terms.each do |search_term|
      search_words = search_term.split
      search_conditions << search_words.map do |word|
        arel_table[:name].lower.matches("%#{word.downcase}%")
      end.reduce(:or)
    end

    # Combine all search conditions into a single condition using the OR operator
    combined_condition = search_conditions.reduce(:or)

    # Find categories that match any of the search terms (case-insensitive)
    where(combined_condition)
  }

end
