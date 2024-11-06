FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    due_date { Date.today }
    status { "To Do" }
    association :user
    association :category
  end
end
