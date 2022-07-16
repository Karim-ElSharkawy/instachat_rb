class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :text, limit: 255
      t.integer :chat_message_number, unsigned: true, null: false, default: 1
      t.belongs_to :chat, index: true, foreign_key: true

      t.timestamps
    end
  end
end
