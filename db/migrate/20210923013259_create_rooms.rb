class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name, null:false
      t.text :description, null:false
      t.boolean :private, null:false, default:false
      t.string :leader, null:false
      t.timestamps
    end
  end
end
