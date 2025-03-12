class CreateBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.references :user_id, foreign_key: true
      t.references :spot_id, foreign_key: true

      t.timestamps
    end
    add_index :bookmarks, [:user_id, :spot_id], unique: true
  end
end
