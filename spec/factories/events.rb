FactoryBot.define do
  factory :event do
    title { Faker::Name.name }
    publish_date { "2024-05-28" }
    time { ["08 AM", "12 PM"].sample }
    venue { Faker::Alphanumeric.alphanumeric }
    description { Faker::Alphanumeric.alphanumeric }
  end
end
