class AddIconPathToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :icon_path, :text
  end
end
