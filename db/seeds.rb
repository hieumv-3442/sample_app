User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true)

25.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true)
end

users = User.order(:created_at).take(6)

30.times do |n|
  content = Faker::Lorem.sentence word_count: 5
  users.each { |user| user.microposts.create! content: content }
end
