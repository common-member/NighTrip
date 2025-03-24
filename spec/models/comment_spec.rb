require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    it '全てのバリデーションが正しく機能すること' do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'bodyが空の場合は無効であること' do
      comment_without_body = build(:comment, body: "")
      expect(comment_without_body).to be_invalid
    end

    it 'bodyが65,535字を超える場合は無効であること' do
      limit_over_body = build(:comment, body: 'あ' * 65_536)
      expect(limit_over_body).to be_invalid
    end
  end
end
