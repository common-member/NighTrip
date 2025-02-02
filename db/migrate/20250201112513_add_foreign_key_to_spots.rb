class AddForeignKeyToSpots < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :spots, :prefectures
  end
end
