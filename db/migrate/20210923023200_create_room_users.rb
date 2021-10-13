class CreateRoomUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :room_users do |t|
      t.references :user,  index: true, foreign_key: true
      t.references :room,  index: true, foreign_key: true
      t.timestamps
    end
  end
end
