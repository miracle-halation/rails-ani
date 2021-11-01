require 'rails_helper'

RSpec.describe 'V1::Tags', type: :request do
  describe 'GET /show' do
    let(:tag) { FactoryBot.create(:tag, name: 'テスト確認タグ') }
    let(:user) { FactoryBot.create(:user, tags: [tag]) }
    it 'ユーザーに紐づいているタグを取得して返す' do
      get v1_tag_path(user.id)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['data'][0]['name']).to eq('テスト確認タグ')
    end
  end
end
