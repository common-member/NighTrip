class AddImageToSpots < ActiveRecord::Migration[7.2]
  def change
    add_column :spots, :image, :string
  end
end
