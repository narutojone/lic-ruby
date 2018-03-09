FactoryBot.define do
  factory :call_center do
    name { Faker::Company.name }
    account
  end
end
