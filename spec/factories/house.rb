FactoryBot.define do
  factory :house do
    name { Faker::Lorem.characters(number:20) }
	end
end