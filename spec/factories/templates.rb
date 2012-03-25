FactoryGirl.define do
  factory :template do
    sequence(:title) { |n| "Template #{n}" }
  end
end
