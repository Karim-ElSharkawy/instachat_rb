# Service Responsible for User Chat's Message Logic.
class MessageService

  def initialize
    super
    @chat_db_service = ChatDbService.new
    @message_db_service = MessageDbService.new
  end

  def create_new(application_token, chat_number, text_value)
    # 1. Find Chat by App token and Chat Number.
    chat_found = @chat_db_service.find_chat(application_token, chat_number)

    # 2.1 if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_found.nil?

    # 2. Create chat using application id and incrementing chat application-specific number.
    new_message = Message.new(
      text: text_value,
      chat_id: chat_found.id,
      chat_message_number: chat_found.messages.count + 1
    )

    SaveMessageJob.perform_later(chat_found.id, new_message.chat_message_number, text_value)

    Response.new(201, 'Message created.', new_message, %i[id chat_id created_at updated_at])
  end

  def update_message(application_token, chat_number, message_number, parameters)
    # 1. Find Chat by App ID and Chat Number.
    message_to_be_updated = @message_db_service.find_message(application_token, chat_number, message_number)

    # if not found, return error response.
    return Response.new(404, 'Message not found.', {}) if message_to_be_updated.nil?

    UpdateMessageJob.perform_later(message_to_be_updated, parameters)

    message_to_be_updated.assign_attributes parameters

    message_to_be_updated
  end

  def show_message(application_token, chat_number, message_number)
    # 1. Find Chat by App ID and Chat Number.
    message_found = @message_db_service.find_message(application_token, chat_number, message_number)

    # 2.1 if not found, return error response.
    return Response.new(404, 'Message not found.', {}) if message_found.nil?

    # 3. Return chat found.
    Response.new(200, 'Message found.', message_found, %i[id chat_id])
  end

  def search(application_token, chat_number, message_text)
    # 1. Find Chat by App ID and Chat Number.
    chat_found = @chat_db_service.find_chat(application_token, chat_number)

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_found.nil?

    result = Message.search(message_text, chat_found.id)

    return Response.new(500, 'Messages could not be searched. Connection timed out.', {}) if result.nil?

    Response.new(200, 'Messages Searched.', result, %i[id chat_id])
  end
end
