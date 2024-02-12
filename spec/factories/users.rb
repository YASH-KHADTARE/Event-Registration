FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6, mix_case: true, special_characters: true)}
    role {'user'}
    full_name {Faker::Name.name}    
  end
end
