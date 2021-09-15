require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  describe 'ユーザー新規登録' do
    context '成功する時' do
      it '値が正しいとデータを登録することができる' do
        expect(user).to be_valid
      end
      it 'iconが空でも登録することができる' do
        user.icon = nil
        expect(user).to be_valid
      end
    end
    context '失敗する時' do
      it 'nicknameが空だと保存できない' do
        user.nickname = ''
        user.valid?
        expect(user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'nicknameが10文字以上だと保存できない' do
        user.nickname = 'a' * 11
        user.valid?
        expect(user.errors.full_messages).to include('Nickname is too long (maximum is 10 characters)')
      end
      it 'emailが空だと保存できない' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include("Email can't be blank")
      end
      it 'emailの形式が違うと保存できない' do
        user.email = 'test.gmail.com'
        user.valid?
        expect(user.errors.full_messages).to include('Email is not an email')
      end
      it 'passwordが空だと保存できない' do
        user.password = ''
        user.valid?
        expect(user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが6文字以下だと保存できない' do
        user.password = 'a'
        user.valid?
        expect(user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'passwordが128文字以上だと保存できない' do
        user.password = 'a' * 200
        user.valid?
        expect(user.errors.full_messages).to include('Password is too long (maximum is 128 characters)')
      end
    end
  end
end
