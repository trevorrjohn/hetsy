FactoryGirl.define do
  factory :exercise_template do
    sequence(:order) { |n| n }
    repetition 1
    association :exercise, factory: :exercise
    association :template, factory: :template
  end
end
