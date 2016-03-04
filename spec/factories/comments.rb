FactoryGirl.define do
  factory :comment do
    association :user, factory: :user
    association :post, factory: :post

    body { Faker::Lorem.paragraph }
  end
end
