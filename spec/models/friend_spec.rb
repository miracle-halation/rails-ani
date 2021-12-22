require 'rails_helper'

RSpec.describe Friend, type: :model do
  let(:friend) { FactoryBot.build(:friend) }
  describe 'フレンド新規作成' do
    context '成功するとき' do
      it 'データが正しいと保存できる' do
        expect(friend).to be_valid
      end
    end
    context '失敗するとき' do
      it 'applicantが空だと保存できない' do
        friend.applicant_id = ''
        friend.valid?
        expect(friend.errors.full_messages).to include("Applicant can't be blank")
      end
      it 'friend_idが空だと保存できない' do
        friend.friend_id = ''
        friend.valid?
        expect(friend.errors.full_messages).to include("Friend can't be blank")
      end
    end
  end
end
