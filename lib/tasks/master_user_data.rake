namespace :db do
  desc "Fill database with Master User data"
  task admin_user_setup: :environment do

    User.create!(name: "Suzuki Naoyuki",
                 email: "naoyuki_suzuki@fexd.co.jp",
                 password: "p_naoyuki",
                 password_confirmation: "p_naoyuki",
                 confirm: true,
                 admin: true)

    User.create!(name: "Koganezawa Ryouta",
                 email: "ryouta_koganezawa@fexd.co.jp",
                 password: "kogane5513",
                 password_confirmation: "kogane5513",
                 confirm: true,
                 admin: true)
  end
end