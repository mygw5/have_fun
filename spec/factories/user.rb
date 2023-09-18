FactoryBot.define do
  factory :user do
    name { "user" }
    email { "test@example.com" }
    password { "test123" }
  end
end
