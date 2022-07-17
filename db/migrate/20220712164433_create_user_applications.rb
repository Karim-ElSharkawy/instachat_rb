# Migration: User Applications Table
class CreateUserApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :user_applications do |t|
      t.string :token, limit: 36, unique: true
      t.string :name, null: false
      t.integer :chats_count, default: 0, unsigned: true

      t.timestamps
    end

    add_index :user_applications, :token
  end
end
