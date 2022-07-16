# Migration: Chats Table
class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :application_chat_number, unsigned: true, null: false, default: 1
      t.integer :messages_count, unsigned: true, default: 0
      t.belongs_to :user_application, index: true, foreign_key: true

      t.timestamps
    end

    add_index :chats, :application_chat_number
  end
end
