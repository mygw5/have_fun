FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    hobby { Faker::Lorem.characters(number: 20)}
    introduction { Faker::Lorem.characters(number: 20) }
    password { 'password' }
    password_confirmation { 'password' }

    after(:build) do |user|
      user.profile_image.attach(io: File.open('spec/images/profile_image.jpg'), filename: 'profile_image.jpg', content_type: 'application/xlsx')
    end
  end
end
