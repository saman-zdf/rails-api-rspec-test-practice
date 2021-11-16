FactoryBot.define do
  factory :user do
    username { "Saman" }
    email { "sam@test.com" }
    password { "password1" }
    password_confirmation { "password1" }
  end
end
