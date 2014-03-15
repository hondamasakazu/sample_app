FactoryGirl.define do

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@fexd.co.jp"}
    password "foobar"
    password_confirmation "foobar"
    confirm true
    factory :admin do
      admin true
    end
  end

  factory :micropost do
    sequence(:content)  { |n| "コンテンツ #{n}" }
    user
  end

  factory :group do
    sequence(:name)  { |n| "GroupName #{n}" }
    sequence(:comment)  { |n| "コメント #{n}" }
  end

end