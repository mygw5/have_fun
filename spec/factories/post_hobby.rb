FactoryBot.define do
  factory :post_hobby do
    title { Faker::Lorem.characters(number:10) }
    text { Faker::Lorem.characters(number:30) }
  end
end