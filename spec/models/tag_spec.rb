require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { FactoryBot.build(:tag) }
  describe 'タグ新規作成' do
    context '成功する時' do
      it '値が正しいとデータを登録することができる' do
        expect(tag).to be_valid
      end
    end
    context '作成できない時' do
      it 'nameが空だと保存できない' do
        tag.name = ''
        tag.valid?
        expect(tag.errors.full_messages).to include("Name can't be blank")
      end
    end
  end
end
