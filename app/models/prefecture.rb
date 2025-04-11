class Prefecture < ApplicationRecord
  # == Constants ==
  REGIONS = {
    0 => "北海道地方",
    1 => "東北地方",
    2 => "関東地方",
    3 => "中部地方",
    4 => "甲信越地方",
    5 => "東海地方",
    6 => "近畿地方",
    7 => "中国地方",
    8 => "四国地方",
    9 => "九州・沖縄地方"
  }.freeze

  # == Associations ==
  has_many :spots

  # == Class Methods ==
  def self.region_options
    REGIONS.map { |key, value| [ value, key ] }
  end
end
