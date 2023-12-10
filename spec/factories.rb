# factories.rb
FactoryBot.define do
  factory :food do
    name { 'Sample food' }
    measurement_unit { 'kg' }
    price { 20 }
    quantity { 3 }
    association :user
  end

  factory :user do
    name { 'John Doe' }
    sequence(:email) { |n| "john#{n}@example.com" }
    password { 'password' }
    admin { false }
  end

  factory :recipe do
    name { 'Example Recipe' }
    description { 'Example Description' }
  end

  factory :inventory do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    association :user, factory: :user
  end
end
