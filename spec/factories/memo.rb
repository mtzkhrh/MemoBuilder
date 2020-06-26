FactoryBot.define do
  factory :memo do
    title { Faker::Lorem.characters(number: 20) }
    body { Faker::Lorem.characters(number: 20) }
    tag_list do
      [
        Faker::Lorem.characters(number: 5),
        Faker::Lorem.characters(number: 5),
        Faker::Lorem.characters(number: 5),
      ]
    end
  end
end
