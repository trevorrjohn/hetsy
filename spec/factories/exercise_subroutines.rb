FactoryGirl.define do
  factory :exercise_subroutine do
    association :exercise, :factory => :exercise
    association :subroutine, :factory => :subroutine
    repetition 5
    order 0
  end
end
