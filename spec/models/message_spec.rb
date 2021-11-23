require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { FactoryBot.build(:message) }
  describe 'メッセージ新規登録' do
    context '作成できる時' do
      it 'データが正しいと保存できる' do
        expect(message).to be_valid
      end
    end
    context '作成できない時' do
      it 'contentが空だと保存できない' do
        message.content = ''
        message.valid?
        expect(message.errors.full_messages).to include("Content can't be blank")
      end
      it 'contentが100文字以上だと保存できない' do
        message.content = 'a' * 101
        message.valid?
        expect(message.errors.full_messages).to include('Content is too long (maximum is 100 characters)')
      end
    end
  end
end
