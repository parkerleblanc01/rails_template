FactoryBot.define do

  factory :transaction do
    symbol { Faker::Company.buzzword }
    description { Faker::Lorem.sentence }
    value { Faker::Number.decimal }
    amount { Faker::Number.decimal }
  end

end