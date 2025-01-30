class ChangeNameLimitInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :name, :string, limit: 100
  end
end
