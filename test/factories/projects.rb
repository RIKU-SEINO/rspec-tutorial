FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "A test project." }
    due_on { 1.week.from_now }
    association :owner

    trait :due_yesterday do
      due_on { 1.day.ago }
    end
    
    trait :due_today do
      due_on { Date.current.in_time_zone }
    end

    trait :due_tomorrow do
      due_on { 1.day.from_now }
    end

    trait :with_notes do
      # traitを使って、projectにwith_notesという新しい属性値セットを定義
      # FactoryBot.create(:project, :with_notes)とすると、project作成後に5つのメモをそのprojectに作成する
      after(:create) { |project| create_list(:note, 5, project: project) }
    end
  end
end
