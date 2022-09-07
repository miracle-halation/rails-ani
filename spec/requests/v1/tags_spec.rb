require 'rails_helper'

RSpec.describe 'V1::Tags', type: :request do
  describe 'GET /show' do
    let(:tag) { FactoryBot.create(:tag, name: 'テスト確認タグ') }
    let(:user) { FactoryBot.create(:user, tags: [tag]) }
    let!(:auth_headers) { login(user) }
    it 'ユーザーに紐づいているタグを取得して返す' do
      get v1_tag_path(user.id), headers: auth_headers
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['data'][0]['name']).to eq('テスト確認タグ')
    end
  end
end
