require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    before(:each) { User.delete_all }

    it '全てのバリデーションが正しく機能すること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'nameが空の場合は無効であること' do
      user_without_name = build(:user, name: "")
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to eq [ "を入力してください" ]
    end

    it 'nameが100文字を超える場合は無効であること' do
      user_over_100_name = build(:user, name: 'あ' * 101)
      expect(user_over_100_name).to be_invalid
    end

    it 'emailが重複している場合は無効であること' do
      create(:user, email: 'same_email@example.com')
      duplicate_email_user = build(:user, email: 'same_email@example.com')
      expect(duplicate_email_user).to be_invalid
      expect(duplicate_email_user.errors[:email]).to eq [ "はすでに存在します" ]
    end
  end
end
