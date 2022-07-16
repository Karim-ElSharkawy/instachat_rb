# Service Responsible for User's Chat Logic.
class ChatService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
    @chat_db_service = ChatDbService.new
  end

  def create_new(application_token)
    SaveChatJob.perform_now(application_token)
  end

  def update_chat(application_token, chat_number, parameters)
    # 1. Find Chat by App ID and Chat Number.
    chat_to_be_updated = @chat_db_service.find_chat(application_token, chat_number)

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_to_be_updated.nil?

    # Lock on record before updating.
    chat_to_be_updated.with_lock do

      # Update Application and return new application on success.
      if Chat.update(chat_to_be_updated.id, parameters)
        Response.new(200, 'Chat updated.', chat_to_be_updated, %i[id user_application_id])
      else
        Response.new(500, 'Chat failed to be updated.', {})
      end
    end
  end

  def show_chat(application_token, chat_number)
    # 1. Find Chat by App ID and Chat Number.
    chat_found = @chat_db_service.find_chat(application_token, chat_number)

    # 2.1 if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_found.nil?

    # 3. Return chat found.
    Response.new(200, 'Chat found.', chat_found, %i[id user_application_id])
  end
end
