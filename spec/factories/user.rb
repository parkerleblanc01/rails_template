FactoryBot.define do

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::Base.numerify('###-###-####') }
    email { Faker::Internet.email }
    random_password = Faker::Internet.password(min_length: 8, max_length: 20)
    password { random_password }
    password_confirmation { random_password }
  end

end