# frozen_string_literal: true

# Job with the responsibility to queue the action to
# insert a new message.
class SaveMessageJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def initialize(*arguments)
    super
    @user_application_db_service = UserApplicationDbService.new
    @chat_db_service = ChatDbService.new
  end

  def perform(chat_identifier, message_count, text_value)
    # 1. Create chat using application id and incrementing chat application-specific number.
    new_message = Message.create(
      text: text_value,
      chat_id: chat_identifier,
      chat_message_number: message_count
    )

    # Async
    UpdateChatMsgCountJob.perform_later(chat_identifier, message_count)

    # 3. Return Response based on the creation status.
    if new_message.save
      Response.new(201, 'Message created.', new_message, %i[id chat_id])
    else
      throw ActiveRecord::RecordNotSaved
    end

  end
end
