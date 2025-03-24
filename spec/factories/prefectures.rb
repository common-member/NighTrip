FactoryBot.define do
  factory :prefecture do
    name { Faker::Address.state }
    region { rand(0..5) }
  end
end
