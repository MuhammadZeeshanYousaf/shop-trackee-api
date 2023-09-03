# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed Categories for Products
product_categories = [
  "Electronics",
  "Fashion",
  "Home & Garden",
  "Toys & Games",
  "Books",
  "Jewelry",
  "Sports and Outdoors",
  "Furniture",
  "Food and Beverages",
  "Art and Crafts",
  "Automotive",
# Add more product categories as needed
]

# Seed Categories for Services
service_categories = [
  "Consulting",
  "Healthcare",
  "Repair",
  "Beauty",
  "Legal Services",
  "Financial Consulting",
  "Educational Services",
  "Event Planning",
  "Fitness and Wellness",
  "Transportation Services",
  "Cleaning Services",
# Add more service categories as needed
]

# Create Categories of type Product
product_categories.map! do |c| { name: c, category_type: Product.to_s } end
Category.create! product_categories
puts "Categories created of type #{Product.to_s}, count: #{Category.count}"

# Create Categories of type Service
service_categories.map! do |c| [ name: c, category_type: Service.to_s] end
Category.create! service_categories
puts "Categories created of type #{Service.to_s}, count: #{Category.count}"

