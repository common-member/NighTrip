class AddAtmosphereToSpots < ActiveRecord::Migration[7.2]
  def change
    add_column :spots, :atmosphere, :string, default: "静か", null: false
  end
end
