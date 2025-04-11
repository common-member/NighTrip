FactoryBot.define do
  factory :spot do
    name { Faker::Lorem.words(number: 2).join(' ') }
    address { Faker::Address.full_address }
    url { Faker::Internet.url }
    body { Faker::Lorem.paragraph_by_chars(number: 300, supplemental: true) }
    atmosphere { Spot::ATMOSPHERE_OPTIONS.sample }

    association :user
    association :prefecture

    # インスタンス生成後でないと、画像はattachできない。
    after(:build) do |spot|
      spot.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
