FactoryBot.define do
  factory :message do
    content { 'テスト投稿' }
    association :user
    association :room
  end
end
