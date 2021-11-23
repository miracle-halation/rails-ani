require 'rails_helper'

RSpec.describe 'V1::Messages', type: :request do
  let!(:room) { FactoryBot.create(:room) }
  let!(:user) { FactoryBot.create(:user) }
  describe 'POST /create' do
    context '成功する時' do
      it 'Messageが作成され、作成したデータを返す' do
        message = { message: { content: '新規投稿', user_id: user.id, room_id: room.id } }
        expect { post v1_messages_path, params: message }.to change(Message, :count).by(1)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['content']).to eq('新規投稿')
      end
    end
    context '失敗する時' do
      it 'contentが空だとメッセージが作成できずエラーを返す' do
        message = { message: { content: '', user_id: user.id, room_id: room.id } }
        expect { post v1_messages_path, params: message }.to change(Message, :count).by(0)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
    end
  end
  describe 'PATCH /update' do
    let!(:message) { FactoryBot.create(:message, content: 'テスト投稿', user_id: user.id, room_id: room.id) }
    context '成功する時' do
      it '値が正しいと更新に成功し、更新したデータを返す' do
        last_message = Message.last
        message = { message: { content: 'テスト更新投稿', user_id: user.id, room_id: room.id } }
        patch v1_message_path(last_message.id, message)
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json['data']['content']).to eq('テスト更新投稿')
      end
    end
    context '失敗する時' do
      it 'contentが空だとメッセージが更新できずエラーを返す' do
        last_message = Message.last
        message = { message: { content: '', user_id: user.id, room_id: room.id } }
        patch v1_message_path(last_message.id, message)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ERROR')
      end
    end
  end
  describe 'DELETE /destroy' do
    let!(:message) { FactoryBot.create(:message, content: 'テスト投稿', user_id: user.id, room_id: room.id) }
    it 'メッセージが削除され、カウントの数が一つ減っている' do
      last_message = Message.last
      expect { delete "/v1/messages/#{last_message.id}" }.to change(Message, :count).by(-1)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('SUCCESS')
    end
  end
end
