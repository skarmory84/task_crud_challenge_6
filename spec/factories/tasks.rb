FactoryBot.define do
  factory :task do
    name { (Faker::Verb.ing_form + ' ' + Faker::Creature::Animal.name).gsub(/[^0-9A-Za-z ]/, '') }
    description { Faker::Lorem.sentence(word_count: 7) }
    status { [:active, :inactive, :in_progress].sample }
    user_id { User.ids.sample }
  end

  trait :active do
    status { :active }
  end

  trait :inactive do
    status { :inactive }
  end

  trait :in_progress do
    status { :in_progress }
  end
end