class AddMessagesToIconPath < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :icon_path, :text
  end
end
