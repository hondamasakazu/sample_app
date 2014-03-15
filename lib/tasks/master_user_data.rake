namespace :db do
  desc "Fill database with Master User data"
  task admin_user_setup: :environment do

    User.create!(name: "",
                 email: "",
                 password: "",
                 password_confirmation: "",
                 confirm: true,
                 admin: true)

    User.create!(name: "",
                 email: "",
                 password: "",
                 password_confirmation: "",
                 confirm: true,
                 admin: true)
  end
end