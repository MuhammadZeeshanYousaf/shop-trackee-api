module NameSearchable
  extend ActiveSupport::Concern

  included do
    # @param query[Array|String]
    # @return [ActiveRecord_Relation]
    scope :search_like, ->(query) {
      query = query.split if query.is_a? String
      # Create an empty array to store individual search conditions
      search_conditions = []

      # Iterate through each search term and build search conditions
      query.each do |search_term|
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

end
