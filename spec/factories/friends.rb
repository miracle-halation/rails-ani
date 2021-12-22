FactoryBot.define do
  factory :friend do
    applicant_id { FactoryBot.create(:user).id }
    friend_id { FactoryBot.create(:user).id }
    accept { 0 }
  end
end
