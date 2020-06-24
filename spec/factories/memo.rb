FactoryBot.define do
  factory :memo do
    title { Faker::Lorem.characters(number:20) }
    body { Faker::Lorem.characters(number:20) }
    tag_list {%w(one two three four five) }
	end
end