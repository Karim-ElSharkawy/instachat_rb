# Service Responsible for User Chat's Message Logic.
class MessageService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
    @chat_db_service = ChatDbService.new
  end

  def create_new(application_token, chat_number, text_value)
    SaveMessageJob.perform_now(application_token, chat_number, text_value)
  end

  def update_message(application_token, chat_number, message_number, parameters)
    # 1. Find Chat by App ID and Chat Number.
    chat_to_be_updated = @chat_db_service.find_chat(application_token, chat_number)

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_to_be_updated.nil?

    message_to_be_updated = Message.find_by(
      chat_id: chat_to_be_updated.id,
      chat_message_number: message_number
    )
    # Lock on record before updating.
    message_to_be_updated.with_lock do

      # Update Application and return new application on success.
      if Message.update(message_to_be_updated.id, parameters)
        Response.new(200, 'Message updated.', message_to_be_updated, %i[id chat_id])
      else
        Response.new(500, 'Message failed to be updated.', {})
      end
    end
  end

  def show_chat(application_token, chat_number, message_number)
    # 1. Find Chat by App ID and Chat Number.
    chat_found = @chat_db_service.find_chat(application_token, chat_number)

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_found.nil?

    message_obj_found = Message.find_by(
      chat_id: chat_found.id,
      chat_message_number: message_number
    )
    # 2.1 if not found, return error response.
    return Response.new(404, 'Message not found.', {}) if message_obj_found.nil?

    # 3. Return chat found.
    Response.new(200, 'Message found.', message_obj_found, %i[id chat_id])
  end
end
