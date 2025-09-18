# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(guid: "e9e06402-757a-4649-9f5c-2961185738a6", name: "Umar Ramadhana")
User.find_or_create_by!(guid: "0b5b8bb9-d38f-4771-9c86-fbff54d901d5", name: "Jhone Doe")
