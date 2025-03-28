FactoryGirl.define do
  factory :user do
    email 'user@email.com'
    password 'password123'
    password_confirmation 'password123'
    remember_me false

    association :role, factory: :role

    trait :admin do
      association :role, factory: [:role, { name: 'Admin' }]
    end

    trait :customer do
      association :role, factory: [:role, { name: 'Customer' }]
    end
  end
end
