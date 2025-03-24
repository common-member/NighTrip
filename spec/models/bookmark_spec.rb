require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  before(:each) { User.delete_all }
  describe 'バリデーション' do
    it '同じuserとspotの組み合わせは一意であること' do
      user = create(:user)
      spot = create(:spot)
      create(:bookmark, user: user, spot: spot)
      duplicate_bookmark = build(:bookmark, user: user, spot: spot)

      expect(duplicate_bookmark).to be_invalid
      expect(duplicate_bookmark.errors[:user_id]).to include('はすでに存在します')
    end
  end

  describe 'アソシエーション' do
    it 'userとの関連付けがあること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'spotとの関連付けがあること' do
      assoc = described_class.reflect_on_association(:spot)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
