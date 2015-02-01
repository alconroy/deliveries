# Seeding teh database with some simple data, for deliveries around dublin

users = [
  User.find_or_create_by(email: "admin@example.com") do |user|
    user.password = "abc123"
    user.password_confirmation = "abc123"
    user.admin = true
  end,
  User.find_or_create_by(email: "normal@example.com") do |user|
    user.password = "abc123"
    user.password_confirmation = "abc123"
    user.van = 1
  end
]

customers = [
  Customer.find_or_create_by(
    code: "LUAS2", 
    name: "Bluebell",
    address: "Naas Rd",
    postcode: "DUB",
    latitude: 53.330, 
    longitude: -6.335
  ),
  Customer.find_or_create_by(
    code: "LUAS3", 
    name: "Drimnagh",
    address: "Bosco Centre",
    postcode: "DUB",
    latitude: 53.335, 
    longitude: -6.318
  ),
  Customer.find_or_create_by(
    code: "LUAS4", 
    name: "Good Counsel",
    address: "GAA Club",
    postcode: "DUB",
    latitude: 53.337, 
    longitude: -6.307
  ),
  Customer.find_or_create_by(
    code: "LUAS5", 
    name: "Heuston",
    address: "Train Station",
    postcode: "DUB",
    latitude: 53.346, 
    longitude: -6.292
  ),
  Customer.find_or_create_by(
    code: "LUAS6", 
    name: "NCI",
    address: "Seat of Learning",
    postcode: "DUB",
    latitude: 53.349, 
    longitude: -6.244
  )
]

deliveries = [
Delivery.find_or_create_by(user_id: users[1].id, customer_id: customers[0].id,
  date: Time.now),
Delivery.find_or_create_by(user_id: users[1].id, customer_id: customers[1].id,
  date: Time.now),
Delivery.find_or_create_by(user_id: users[1].id, customer_id: customers[2].id,
  date: Time.now),
Delivery.find_or_create_by(user_id: users[1].id, customer_id: customers[3].id,
  date: Time.now),
Delivery.find_or_create_by(user_id: users[1].id, customer_id: customers[4].id,
  date: Time.now)
]

locations = [
Location.find_or_create_by(user_id: users[1].id, time: 2.minutes.ago) do |loc|
  loc.latitude = 53.31792
  loc.longitude = -6.37034
end
]