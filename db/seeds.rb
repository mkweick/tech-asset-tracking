MFG = ["HP", "Dell", "Toshiba", "Panasonic", "Apple", "LG", "Samsung"]

User.create!  username: "mweick", first_name: "Matt", last_name: "Weick",
              email: "mkweick@gmail.com", password: "weick18", admin: true

139.times do |n|
  User.create!  username: "example#{n + 1}",
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: "example#{n + 1}@example.com",
                password: "example#{n + 1}",
                password_confirmation: "example#{n + 1}"
end

Category.create!([{ name: "Desktops"}, { name: "Laptops"}, { name: "Keyboards"},
                  { name: "Cell Phones"}, { name: "Tablets"}, { name: "Speakers"},
                  { name: "Projectors"}, { name: "Chargers"}, { name: "Monitors"},
                  { name: "Headphones"}, { name: "Flash Drives"}, { name: "Hotspots"}])

101.times do |n|
  if n.even? && n > 0
    FixedAsset.create!  category_id: 1,
                        mfg_name: "HP",
                        model_num: "Compaq 8300",
                        serial_num: "SMPROHPDV#{n}",
                        description: "500GB HDD, 8GB RAM, Win 7 Pro, Slim " + 
                                      "Line, Professional Grade",
                        purchase_date: Time.now
    
    FixedAssignment.create! user_id: n,
                            fixed_asset_id: n
  end
end

101.times do |n|
  if n.odd?
    FixedAsset.create!  category_id: 2,
                        mfg_name: "Dell",
                        model_num: "Latitude 5000",
                        serial_num: "DVPROSMP#{n}",
                        description: "15.4\" glossy screen, 500GB SSD Drive, " + 
                                      "8GB RAM, Win 7 Pro, 8 lbs, .75\" thick",
                        purchase_date: Time.now
    
    FixedAssignment.create! user_id: n,
                            fixed_asset_id: n
  end
end

201.times do |n|
  if n > 100
    FixedAsset.create!  category_id: rand(3..12),
                        mfg_name: MFG.sample,
                        model_num: "Tester " + Faker::Number.number(3).to_s,
                        serial_num: Faker::Number.number(10),
                        description: "This is a generic test asset description",
                        purchase_date: Time.now
  end
end

20.times do |n|
  FixedAsset.create!  category_id: (n.even? ? 1 : 2),
                      mfg_name: MFG.sample,
                      model_num: "Tester " + Faker::Number.number(3).to_s,
                      serial_num: Faker::Number.number(10),
                      description: "This is a generic test asset description",
                      purchase_date: Time.now
end

176.times do |n|
  if n > 100
    FixedAssignment.create! user_id: rand(1..140),
                            fixed_asset_id: n
  end
end

75.times do |n|
  UnfixedAsset.create!  category_id: rand(1..12),
                        mfg_name: MFG.sample,
                        model_num: "Tester " + Faker::Number.number(3).to_s,
                        serial_num: Faker::Number.number(10),
                        description: "This is a generic test asset description",
                        purchase_date: Time.now
end

35.times do |n|
  UnfixedAssignment.create! user_id: rand(1..140),
                            unfixed_asset_id: (n + 1) 
end

puts "-" * 60
puts
puts "Users created:      #{User.all.size}/140"
puts "Categories created: #{Category.all.size}/12"
puts "Fixed Assigned Desktops created: #{FixedAsset.all
                                    .where("category_id = ? AND id < ?", 1, 101)
                                    .size}/50"
puts "Fixed Assigned Laptops created: #{FixedAsset.all
                                    .where("category_id = ? AND id < ?", 2, 101)
                                    .size}/50"
puts "Fixed Unassigned Desktops/Laptops created: #{FixedAsset.all
                                                          .where("id > ?", 200)
                                                          .size}/20"
puts "Fixed Desktop/Laptop Assignments created: #{FixedAssignment.all
                                              .where("fixed_asset_id <= ?", 100)
                                              .size}/100"
puts "Fixed General Assets created: #{FixedAsset.all.where("category_id > ?", 2)
                                                    .size}/100"
puts "Fixed General Assignments created: #{FixedAssignment.all
                                              .where("fixed_asset_id > ?", 100)
                                              .size}/75"
puts "Unfixed Assets created: #{UnfixedAsset.all.size}/75"
puts "Unfixed Assignments created: #{UnfixedAssignment.all.size}/35"
puts
puts "-" * 60