class AddChatColorToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :chat_color, :string
  end
end
