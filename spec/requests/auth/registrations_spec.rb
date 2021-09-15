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

  describe 'Post /auth/sign_in' do
    let!(:user) { FactoryBot.create(:user) }
    context '値が正しいとき' do
      it '認証に成功し、成功したデータを返す' do
        test_params = { email: 'test@gmail.com', password: 'testtest' }
        post '/auth/sign_in', params: test_params
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['email']).to eq(user.email)
        expect(json['data']['nickname']).to eq(user.nickname)
      end
    end
    context '値が間違っているとき' do
      it 'emailが違うと認証に失敗し、Invalidを返す' do
        test_params = { email: 'test_failed@gmail.com', password: 'testtest' }
        post '/auth/sign_in', params: test_params
        json = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(json['success']).to be_falsey
        expect(json['errors'][0]).to eq('Invalid login credentials. Please try again.')
      end
      it 'passwordが違うと認証に失敗し、Invalidを返す' do
        test_params = { email: 'test@gmail.com', password: 'password_failed' }
        post '/auth/sign_in', params: test_params
        json = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(json['success']).to be_falsey
        expect(json['errors'][0]).to eq('Invalid login credentials. Please try again.')
      end
    end
  end
end
