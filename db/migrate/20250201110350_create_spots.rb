class CreateSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :spots do |t|
      t.string :name
      t.integer :prefecture_id
      t.string :address
      t.string :url
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
