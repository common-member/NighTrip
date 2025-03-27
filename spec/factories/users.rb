FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}_#{SecureRandom.hex(4)}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
