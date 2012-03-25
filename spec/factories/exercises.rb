FactoryGirl.define do
  factory :exercise do
    sequence(:title) { |n| "Exercise #{n}" }
    value 5
  end
end
