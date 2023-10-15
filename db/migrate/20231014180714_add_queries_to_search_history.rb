class AddQueriesToSearchHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :search_histories, :queries, :text, array: true, default: []
  end
end
