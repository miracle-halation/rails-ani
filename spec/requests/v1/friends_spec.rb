require 'rails_helper'

RSpec.describe 'V1::Friends', type: :request do
  # ログインユーザー
  let!(:user) { FactoryBot.create(:user) }
  let!(:auth_headers) { login(user) }

  # フレンド承認済みユーザー
  let!(:apply_user) { FactoryBot.create(:user) }
  let!(:apply_friend) { FactoryBot.create(:friend, friend_id: user.id, applicant_id: apply_user.id, accept: 1) }
  let!(:applicant_friend) { FactoryBot.create(:friend, friend_id: apply_user.id, applicant_id: user.id, accept: 1) }

  # フレンド保留中
  let!(:pending_friend) { FactoryBot.create(:friend, friend_id: user.id) }

  describe 'GET /show' do
    it '正しい値を返している' do
      get v1_friend_path(user.id), headers: auth_headers
      json = JSON.parse(response.body)
      # 承認済みフレンド一覧
      apply_friends = json['data'][0]
      apply_friends_ids = apply_friends.map { |value| value['id'] }
      # 保留中フレンド一覧
      pending_friends = json['data'][1]
      pending_friends_ids = pending_friends.map { |value| value['id'] }

      expect(response.status).to eq(200)
      expect(apply_friends_ids).to include(apply_user.id)
      expect(pending_friends_ids).to include(pending_friend.applicant_id)
    end
  end
  describe 'DELETE /destroy' do
    it 'フレンドを削除することができる' do
      expect { delete v1_friend_path(user.id, friend_id: apply_user.id), headers: auth_headers }.to change(Friend, :count).by(-2)
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
        expect do
          post apply_v1_friends_path(user_id: user.id, friend_id: pending_user.id), headers: auth_headers
        end.to change(Friend, :count).by(1)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('SUCCESS')
        expect(json['data']).to eq('フレンド申請に成功しました')
        expect(json['color']).to eq('green')
      end
    end
    context '失敗するとき' do
      it 'friendテーブルが増えず、指定の値を返す' do
        expect do
          post apply_v1_friends_path(user_id: user.id, friend_id: apply_user.id), headers: auth_headers
        end.to change(Friend, :count).by(0)
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
        expect do
          post approval_v1_friends_path(user_id: user.id, friend_id: pending_user.id),
               headers: auth_headers
        end.to change(Friend, :count).by(1)
        expect(applicant_friend.accept).to be true
        json = JSON.parse(response.body)
        expect(json['status']).to eq('SUCCESS')
        expect(json['data']).to eq('承認に成功しました')
        expect(json['color']).to eq('green')
      end
    end
    context '失敗するとき' do
      it 'friendテーブルが増えず、指定の値を返す' do
        expect do
          post approval_v1_friends_path(user_id: user.id, friend_id: apply_user.id),
               headers: auth_headers
        end.to change(Friend, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
        expect(json['data']).to eq('承認に失敗しました')
        expect(json['color']).to eq('red')
      end
    end
  end
end
