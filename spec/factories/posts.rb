FactoryGirl.define do
  factory :post do
    sequence(:title)      { |n| "#{Faker::Company.bs}-#{n}" }
    sequence(:body)       { |n| "#{Faker::Lorem.paragraph}-#{n}" }
  end
end
