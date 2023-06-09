FactoryBot.define do
  factory :task do
    name { Faker::Verb.ing_form + ' ' + Faker::Creature::Animal.name }
    description { Faker::Lorem.sentence(word_count: 7) }
    status { [:active, :inactive, :in_progress].sample }
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