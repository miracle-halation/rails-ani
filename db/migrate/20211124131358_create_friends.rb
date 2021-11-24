class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.integer :applicant
      t.integer :friend_id

      t.timestamps
    end
    add_index :friends, :applicant
    add_index :friends, :friend_id
    add_index :friends, [:applicant, :friend_id], unique: true
  end
end
