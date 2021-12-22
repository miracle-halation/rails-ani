require 'rails_helper'

RSpec.describe 'V1::Friends', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:friend_user) { FactoryBot.create(:user) }
  let!(:pending_friend) { FactoryBot.create(:friend, friend_id: user.id) }
  let!(:friend) { FactoryBot.create(:friend, friend_id: user.id, applicant_id: friend_user.id, accept: 1) }
  let!(:applicant_friend) { FactoryBot.create(:friend, friend_id: friend_user.id, applicant_id: user.id, accept: 1) }
  describe 'GET /show' do
    it '正しい値を返している' do
      get v1_friend_path(user.id)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['data'][0][0]['id']).to eq(friend_user.id)
      expect(json['data'][1][1]['id']).to eq(pending_friend.applicant_id)
    end
  end
  describe 'DELETE /destroy' do
    it 'フレンドを削除することができる' do
      expect { delete v1_friend_path(user.id, friend_id: friend_user.id) }.to change(Friend, :count).by(-2)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('SUCCESS')
      expect(json['data']).to eq('フレンド解除に成功しました')
      expect(json['color']).to eq('green')
    end
  end
  describe 'POST /apply' do
    let!(:pending_user) { FactoryBot.create(:user) }
    context '成功するとき' do
      it 'friendテーブルが増えて、指定の値を返す' do
        expect { post apply_v1_friends_path(user_id: user.id, friend_id: pending_user.id) }.to change(Friend, :count).by(1)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('SUCCESS')
        expect(json['data']).to eq('フレンド申請に成功しました')
        expect(json['color']).to eq('green')
      end
    end
    context '失敗するとき' do
      it 'friendテーブルが増えず、指定の値を返す' do
        expect { post apply_v1_friends_path(user_id: user.id, friend_id: friend_user.id) }.to change(Friend, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
        expect(json['data']).to eq('すでにフレンド登録されています')
        expect(json['color']).to eq('red')
      end
    end
  end
  describe 'POST /approval' do
    let!(:pending_user) { FactoryBot.create(:user) }
    let!(:approval_friend) { FactoryBot.create(:friend, friend_id: user.id, applicant_id: pending_user.id) }
    context '成功するとき' do
      it 'friendテーブルが増えず、指定の値を返す' do
        expect { post approval_v1_friends_path(user_id: user.id, friend_id: pending_user.id) }.to change(Friend, :count).by(1)
        expect(applicant_friend.accept).to be true
        json = JSON.parse(response.body)
        expect(json['status']).to eq('SUCCESS')
        expect(json['data']).to eq('承認に成功しました')
        expect(json['color']).to eq('green')
      end
    end
    context '失敗するとき' do
      it 'friendテーブルが増えず、指定の値を返す' do
        expect { post approval_v1_friends_path(user_id: user.id, friend_id: friend_user.id) }.to change(Friend, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
        expect(json['data']).to eq('承認に失敗しました')
        expect(json['color']).to eq('red')
      end
    end
  end
end
