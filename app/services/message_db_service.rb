# Chat Database Layer to check Cache for frequently looked tokens.
class MessageDbService
  def initialize
    super
    @chat_db_service = ChatDbService.new
  end

  def find_message(application_token, chat_number, message_number)
    chat_found = @chat_db_service.find_chat(application_token, chat_number)

    return nil if chat_found.nil?

    FetchMessageJob.perform_now(chat_found.id, message_number)
  end
end
