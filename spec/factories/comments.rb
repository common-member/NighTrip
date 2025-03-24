FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph_by_chars(number: 65_535, supplemental: true) }

    association :user
    association :spot
  end
end
