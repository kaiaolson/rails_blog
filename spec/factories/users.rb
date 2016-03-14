FactoryGirl.define do
  factory :user do
    first_name        {Faker::Name.first_name}
    last_name         {Faker::Name.first_name}
    sequence(:email)  {|n| "#{n}-#{Faker::Internet.email}"}
    password          {Faker::Internet.password}
  end
end
