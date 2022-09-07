require 'rails_helper'

RSpec.describe 'Auth::Registrations', type: :request do
  describe 'Post /auth' do
    context '成功する時' do
      it '送信されたパラメータが正しいとデータが作成される' do
        test_params = { nickname: 'test', email: 'test@gmail.com', password: 'testtest' }
        expect { post '/auth', params: test_params }.to change(User, :count).by(1)
        expect(response.status).to eq(200)
      end
    end
    context '失敗する時' do
      it 'nicknameが空だとデータが作成されない' do
        test_params = { nickname: '', email: 'test@gmail.com', password: 'testtest' }
        expect { post '/auth', params: test_params }.to change(User, :count).by(0)
        expect(response.status).to eq(422)
      end
      it 'emailが空だとデータが作成されない' do
        test_params = { nickname: 'test', email: '', password: 'testtest' }
        expect { post '/auth', params: test_params }.to change(User, :count).by(0)
        expect(response.status).to eq(422)
      end
      it 'passwordが空だとデータが作成されない' do
        test_params = { nickname: 'test', email: 'test@gmail.com', password: '' }
        expect { post '/auth', params: test_params }.to change(User, :count).by(0)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'Put /auth' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:auth_headers) { login(user) }
    context '値が正しいとき' do
      it 'userの情報を更新することができる' do
        test_params = { id: user.id, address: 'アップデートテスト団地', myinfo: 'アップデートテスト自己紹介', tags: 'テストタグ, テスト２タグ' }
        expect(user.address).not_to eq('アップデートテスト団地')
        put '/auth', params: test_params, headers: auth_headers
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['address']).to eq('アップデートテスト団地')
        expect(json['data']['myinfo']).to eq('アップデートテスト自己紹介')
      end
    end
  end

  describe 'Delete /auth' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:auth_headers) { login(user) }
    it 'userを削除することができる' do
      test_params = { id: user.id }
      expect { delete '/auth', params: test_params, headers: auth_headers }.to change(User, :count).by(-1)
    end
  end
end
