User.create!  username: "mweick", first_name: "Matt", last_name: "Weick",
              email: "mkweick@gmail.com", password: "weick18", admin: true

89.times do |n|
  User.create!  username: "example#{n + 1}",
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: "example#{n + 1}@example.com",
                password: "weick18",
                password_confirmation: "weick18"
end

Category.create!([{ name: "Desktops"}, { name: "Laptops"}, { name: "Keyboards"},
                  { name: "Cell Phones"}, { name: "Tablets"}, { name: "Speakers"},
                  { name: "Projectors"}, { name: "Chargers"}, { name: "Monitors"},
                  { name: "Headphones"}, { name: "Flash Drives"}, { name: "Hotspots"}])

100.times do |n|
  FixedAsset.create!  category_id: rand(1..12),
                      mfg_name: "HP",
                      model_num: "HPTEST01",
                      serial_num: "HPDEV123",
                      description: "Test description of product",
                      purchase_date: Time.now
end

100.times do |n|
  FixedAssignment.create! user_id: rand(1..90),
                          fixed_asset_id: rand(1..100)
end

50.times do |n|
  UnfixedAsset.create!  category_id: rand(1..12),
                        mfg_name: "HP",
                        model_num: "HPTEST01",
                        serial_num: "HPDEV123",
                        description: "Test description of product",
                        purchase_date: Time.now
end

20.times do |n|
  UnfixedAssignment.create! user_id: rand(1..90),
                            unfixed_asset_id: rand(1..50)
end

puts "-" * 40
puts
puts "Users created:      #{User.all.size}/90"
puts "Categories created: #{Category.all.size}/12"
puts "Fixed Assets created: #{FixedAsset.all.size}/100"
puts "Fixed Assignments created: #{FixedAssignment.all.size}/100"
puts "Unfixed Assets created: #{UnfixedAsset.all.size}/50"
puts "Unfixed Assignments created: #{UnfixedAssignment.all.size}/20"
puts
puts "-" * 40