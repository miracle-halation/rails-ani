require 'rails_helper'

RSpec.describe 'V1::Rooms', type: :request do
  let!(:room) { FactoryBot.create_list(:room, 5) }
  let(:user) { FactoryBot.create(user) }
  describe 'GET /index' do
    it 'Roomの一覧データを返す' do
      get v1_rooms_path
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['data'].length).to eq(5)
    end
  end
  describe 'GET /show' do
    let!(:room) { FactoryBot.create(:room, name: 'テスト確認ルーム') }
    it 'Roomの詳細データを取得する' do
      room = Room.last
      get v1_room_path(room.id)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['data'][0]['name']).to eq('テスト確認ルーム')
    end
  end
  describe 'POST /create' do
    context '成功する時' do
      it 'ルームが作成され、作成したデータを返す' do
        room = { room: { name: 'テスト確認ルーム', description: 'テスト確認', private: false, leader: 'test' }, user_ids: [1, 2, 3] }
        expect { post v1_rooms_path, params: room }.to change(Room, :count).by(1)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['name']).to eq('テスト確認ルーム')
      end
    end
    context '失敗する時' do
      it 'nameが空だとルームが作成できずエラーを返す' do
        room = { room: { name: '', description: 'テスト確認', private: false, leader: 'test' }, user_ids: [1, 2, 3] }
        expect { post v1_rooms_path, params: room }.to change(Room, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
      it 'descriptionが空だとルームが作成できずエラーを返す' do
        room = { room: { name: 'テスト確認ルーム', description: '', private: false, leader: 'test' }, user_ids: [1, 2, 3] }
        expect { post v1_rooms_path, params: room }.to change(Room, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
      it 'leaderが空だとルームが作成できずエラーを返す' do
        room = { room: { name: 'テスト確認ルーム', description: 'テスト確認', private: false, leader: '' }, user_ids: [1, 2, 3] }
        expect { post v1_rooms_path, params: room }.to change(Room, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
    end
  end
  describe 'PATCH /update' do
    let!(:room) { FactoryBot.create(:room, name: 'テスト確認ルーム') }
    context '成功する時' do
      it '値が正しいと更新に成功し、更新したデータを返す' do
        last_room = Room.last
        room = { room: { name: 'テスト確認ルーム更新', description: 'テスト確認', private: false, leader: 'test' } }
        patch v1_room_path(last_room.id, room)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['name']).to eq('テスト確認ルーム更新')
      end
    end
    context '失敗する時' do
      it 'nameが空だとルームが更新できずエラーを返す' do
        last_room = Room.last
        room = { room: { name: '', description: 'テスト確認', private: false, leader: 'test' } }
        patch v1_room_path(last_room.id, room)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
      it 'descriptionが空だとルームが更新できずエラーを返す' do
        last_room = Room.last
        room = { room: { name: 'テスト確認ルーム', description: '', private: false, leader: 'test' } }
        patch v1_room_path(last_room.id, room)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
      it 'leaderが空だとルームが更新できずエラーを返す' do
        last_room = Room.last
        room = { room: { name: 'テスト確認ルーム', description: 'テスト確認', private: false, leader: '' } }
        patch v1_room_path(last_room.id, room)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
    end
  end
  describe 'DELETE /destroy' do
    let!(:room) { FactoryBot.create(:room, name: 'テスト確認ルーム') }
    it 'roomが削除され、カウントの数が一つ減っている' do
      last_room = Room.last
      expect { delete "/v1/rooms/#{last_room.id}" }.to change(Room, :count).by(-1)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('SUCCESS')
    end
  end
end
