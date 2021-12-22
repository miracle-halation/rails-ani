FactoryBot.define do
  factory :user do
    nickname	{ 'test' }
    email	{ Faker::Internet.email }
    password	{ 'testtest' }
    address { 'テストマンション' }
    myinfo { 'テスト自己紹介' }
  end
end
