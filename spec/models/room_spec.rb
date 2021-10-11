require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.build(:room) }
  describe 'ルーム新規登録' do
    context '作成できる時' do
      it 'データが正しいと保存できる' do
        expect(room).to be_valid
      end
    end
    context '作成できない時' do
      it 'nameが空だと保存できない' do
        room.name = ''
        room.valid?
        expect(room.errors.full_messages).to include("Name can't be blank")
      end
      it 'nameが25文字以上だと保存できない' do
        room.name = 'a' * 26
        room.valid?
        expect(room.errors.full_messages).to include('Name is too long (maximum is 25 characters)')
      end
      it 'descriptionが空だと保存できない' do
        room.description = ''
        room.valid?
        expect(room.errors.full_messages).to include("Description can't be blank")
      end
      it 'nameが25文字以上だと保存できない' do
        room.description = 'a' * 501
        room.valid?
        expect(room.errors.full_messages).to include('Description is too long (maximum is 500 characters)')
      end
      it 'leaderが空だと保存できない' do
        room.leader = ''
        room.valid?
        expect(room.errors.full_messages).to include("Leader can't be blank")
      end
    end
  end
end
