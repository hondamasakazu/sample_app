namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    User.create!(name: "Example User",
                 email: "example@fexd.co.jp",
                 password: "foobar",
                 password_confirmation: "foobar",
                 confirm: true,
                 admin: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@fexd.co.jp"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   confirm: true)
    end

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

  end
end