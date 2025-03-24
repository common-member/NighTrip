require 'rails_helper'

RSpec.describe Spot, type: :model do
  describe 'バリデーション' do
    it '全てのバリデーションが正しく機能すること' do
      spot = build(:spot)
      expect(spot).to be_valid
    end

    it 'nameが空の場合は無効であること' do
      spot_without_name = build(:spot, name: "")
      expect(spot_without_name).to be_invalid
    end

    it 'addressが空の場合は無効であること' do
      spot_without_address = build(:spot, address: "")
      expect(spot_without_address).to be_invalid
    end

    it 'urlが空文字でなく、かつ不正な形式の場合は無効であること' do
      spot = build(:spot, url: 'invalid_url')
      expect(spot).to be_invalid
      expect(spot.errors[:url]).to include('は有効なURL形式でなければなりません')
    end

    it 'urlが空の場合は有効であること（allow_blankが効いている）' do
      spot = build(:spot, url: '')
      expect(spot).to be_valid
    end

    it 'urlがnilの場合は有効であること（allow_blankが効いている）' do
      spot = build(:spot, url: nil)
      expect(spot).to be_valid
    end

    it 'bodyが5000字を超える場合は無効であること' do
      spot_over_limit = build(:spot, body: 'あ' * 5001)
      expect(spot_over_limit).to be_invalid
      expect(spot_over_limit.errors[:body]).to include("は5000文字以内で入力してください")
    end

    it 'imageが空の場合は無効であること' do
      spot_without_image = build(:spot)
      spot_without_image.image.detach
      expect(spot_without_image).to be_invalid
      expect(spot_without_image.errors[:image]).to include("を入力してください")
    end
  end
end
