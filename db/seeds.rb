# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!  username: "mweick", first_name: "Matt", last_name: "Weick",
              email: "mkweick@gmail.com", password: "hhockey18", admin: true

24.times do
  User.create!  username: Faker::Internet.user_name,
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.safe_email,
                password: Faker::Internet.password(6, 6)
end

puts "-" * 100
puts "Users created: #{User.all.size}"
puts "-" * 100