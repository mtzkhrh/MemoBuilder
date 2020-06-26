FactoryBot.define do
  factory :room do
    name { Faker::Lorem.characters(number: 20) }
  end
end
