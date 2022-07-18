class FetchChatJob < ApplicationJob
  queue_as :default

  def perform(application_id, chat_number)
    Chat.find_by(user_application_id: application_id, application_chat_number: chat_number)
  end
end
