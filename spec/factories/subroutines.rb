
FactoryGirl.define do
  factory :subroutine do
    sequence(:title) { |n| "Subroutine #{n}"}
  end
end
