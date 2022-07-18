# frozen_string_literal: true

# Job with the responsibility to queue the action to
# insert a new chat.
class SaveChatJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def perform(application_id, chat_number)
    new_chat = Chat.create(
      user_application_id: application_id,
      application_chat_number: chat_number
    )

    # Return Response based on the creation status.
    if new_chat.save
      # Async
      UpdateChatCountJob.perform_later(application_id, chat_number)
    else
      throw ActiveRecord::RecordNotSaved
    end

  end
end
