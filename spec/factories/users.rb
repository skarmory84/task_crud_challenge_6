FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'strongpassword' }
  end

  trait :normal do
    user_type { :normal }
  end

  trait :editor do
    user_type { :editor }
  end

  trait :admin do
    user_type { :admin }
  end
end