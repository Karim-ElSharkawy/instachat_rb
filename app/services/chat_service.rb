# Service Responsible for User's Chat Logic.
class ChatService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
    @chat_db_service = ChatDbService.new
  end

  def create_new(application_token)
    # 1. Find application by token.
    user_application = @user_application_db_service.find_app_by_token(application_token)

    # 1.1 if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if user_application.nil?

    # 2. Create chat using application id and incrementing chat application-specific number.
    new_chat = Chat.new(
      user_application_id: user_application.id,
      application_chat_number: user_application.chats.count + 1
    )

    # Save the Chat (Async).
    SaveChatJob.perform_later(new_chat.user_application_id, new_chat.application_chat_number)

    Response.new(201, 'Chat created.', new_chat, %i[id user_application_id created_at updated_at])
  end

  def update_chat(application_token, chat_number, parameters)
    # 1. Find Chat by App ID and Chat Number.
    chat_to_be_updated = @chat_db_service.find_chat(application_token, chat_number)

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_to_be_updated.nil?

    # Async update chat job.
    UpdateChatJob.perform_later(application_token, chat_to_be_updated, parameters)

    # Update Application and return new application on success.
    chat_to_be_updated.assign_attributes(parameters)

    Response.new(200, 'Chat updated.', chat_to_be_updated, %i[id user_application_id])
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
