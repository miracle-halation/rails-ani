class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.integer :applicant_id
      t.integer :friend_id
      t.boolean :accept, default: false

      t.timestamps
    end
    add_index :friends, :applicant_id
    add_index :friends, :friend_id
    add_index :friends, [:applicant_id, :friend_id], unique: true
  end
end
