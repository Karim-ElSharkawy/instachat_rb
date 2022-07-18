class FetchMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_identifier, message_number)
    Message.find_by(
      chat_id: chat_identifier,
      chat_message_number: message_number
    )
  end
end
