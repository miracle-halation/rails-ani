FactoryBot.define do
  factory :room do
    name { 'testルーム' }
    description { 'テストの説明' }
    private { false }
    leader { '1' }
    genre { 'ゲーム' }
  end
end
