# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_07_183020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "category_type"
    t.bigint "parent_id", comment: "Category can be sub-category and it will have a parent."
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "vocation"
    t.integer "age"
    t.boolean "newsletter_subscribed", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "favoritable_id", comment: "Product or Service Id"
    t.string "favoritable_type", comment: "Product or Service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_favorites_on_customer_id"
    t.index ["favoritable_id", "favoritable_type"], name: "index_favorites_on_favoritable_id_and_favoritable_type"
  end

  create_table "order_requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "message"
    t.bigint "customer_id", null: false
    t.bigint "shop_id"
    t.string "orderable_type"
    t.bigint "orderable_id"
    t.string "removed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["customer_id"], name: "index_order_requests_on_customer_id"
    t.index ["orderable_type", "orderable_id"], name: "index_order_requests_on_orderable"
    t.index ["shop_id"], name: "index_order_requests_on_shop_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.float "price", default: 1.0
    t.integer "stock_quantity", default: 1
    t.bigint "category_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "search_histories", force: :cascade do |t|
    t.string "name", comment: "Customer Search History text"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_search_histories_on_customer_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.text "intro", comment: "A short introduction for customers."
    t.integer "rating", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sellers_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.float "rate", default: 1.0
    t.integer "charge_by", default: 0, comment: "A rails enum, it could be charge by hour, day, work respectively."
    t.bigint "category_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["shop_id"], name: "index_services_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "contact", comment: "Business contact number."
    t.integer "closing_days", default: [], null: false, comment: "In these days the shop is closed, starting from Monday:0", array: true
    t.string "social_links", default: [], array: true
    t.string "shop_website_url", comment: "Online shop website url if exists."
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "closing_time"
    t.datetime "opening_time"
    t.jsonb "address", default: {}, comment: "Stores address in json as received from Google Map"
    t.index ["closing_days"], name: "index_shops_on_closing_days", using: :gin
    t.index ["seller_id"], name: "index_shops_on_seller_id"
    t.index ["social_links"], name: "index_shops_on_social_links", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "gender"
    t.string "country", default: "Pakistan"
    t.string "phone"
    t.text "address"
    t.string "avatar"
    t.string "role", default: "customer"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "customers", "users"
  add_foreign_key "favorites", "customers"
  add_foreign_key "order_requests", "customers"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "shops"
  add_foreign_key "search_histories", "customers"
  add_foreign_key "sellers", "users"
  add_foreign_key "services", "categories"
  add_foreign_key "services", "shops"
  add_foreign_key "shops", "sellers"
end
