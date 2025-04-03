class AddChatColorToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :chat_color)
      add_column :users, :chat_color, :string
    end
  end
end
