# frozen_string_literal: true

# Job with the responsibility to queue the action to
# insert a new message.
class SaveMessageJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def initialize(*arguments)
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def perform(application_token, chat_number, text_value)
    # 1. Find Application by Token.
    application_found = @user_application_db_service.find_app_by_token(application_token)

    # 1.1 if not found, return error response.
    throw ActiveRecord::RecordNotFound if application_found.nil?

    # 2. Find Chat by App ID and Chat Number.
    chat_found = Chat.find_by(
      user_application_id: application_found.id,
      application_chat_number: chat_number
    )

    # 2.1 if not found, return error response.
    throw ActiveRecord::RecordNotFound if chat_found.nil?

    # 2. Create chat using application id and incrementing chat application-specific number.
    new_message = Message.create(
      text: text_value,
      chat_id: chat_found.id,
      chat_message_number: chat_found.messages.count + 1
    )

    # Async
    UpdateChatMsgCountJob.perform_later(chat_found.id, new_message.chat_message_number)

    # 3. Return Response based on the creation status.
    if new_message.save
      Response.new(201, 'Message created.', new_message, %i[id chat_id])
    else
      throw ActiveRecord::RecordNotSaved
    end

  end
end
