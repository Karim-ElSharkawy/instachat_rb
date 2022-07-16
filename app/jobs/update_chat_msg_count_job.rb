# frozen_string_literal: true

# Job with the responsibility to queue the action
# to update the given chat with the given new_count in the database.
class UpdateChatMsgCountJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def perform(chat_id, new_count)
    # Update Chat with new messages count.
    if Chat.update(chat_id, messages_count: new_count)
      true
    else
      throw ActiveRecord::RecordNotSaved
    end
  end
end
