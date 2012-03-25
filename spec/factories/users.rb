# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Example User"
    sequence(:email) { |n| "user#{n}@example.com" }
    password "MyString"
    password_confirmation "MyString"

    factory :admin do
      admin true
    end
  end
end
