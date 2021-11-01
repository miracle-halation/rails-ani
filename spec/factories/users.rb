FactoryBot.define do
  factory :user do
    nickname	{ 'test' }
    email	{ 'test@gmail.com' }
    password	{ 'testtest' }
    address { 'テストマンション' }
    myinfo { 'テスト自己紹介' }
  end
end
