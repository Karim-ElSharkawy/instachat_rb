# Service Responsible for User's Chat Logic.
class ChatService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def create_new(application_token)
    SaveChatJob.perform_now(application_token)
  end

  def update_chat(application_token, chat_number, parameters)
    # Find Application by Token.
    application_found = @user_application_db_service.find_app_by_token(application_token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_found.nil?

    chat_to_be_updated = Chat.find_by(
      user_application_id: application_found.id,
      application_chat_number: chat_number
    )

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

  def delete_chat(application_token, chat_number)
    # Find Application by Token.
    application_found = @user_application_db_service.find_app_by_token(application_token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_found.nil?

    chat_to_be_deleted = Chat.find_by(
      user_application_id: application_found.id,
      application_chat_number: chat_number
    )

    # if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_to_be_deleted.nil?

    # Lock on record before updating.
    chat_to_be_deleted.with_lock do

      # Update Application and return new application on success.
      if Chat.delete(chat_to_be_deleted.id)
        Response.new(200, 'Chat deleted.', {})
      else
        Response.new(500, 'Chat failed to be updated.', {})
      end
    end
  end

  def show_chat(application_token, chat_number)
    # 1. Find Application by Token.
    application_found = @user_application_db_service.find_app_by_token(application_token)

    # 1.1 if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_found.nil?

    # 2. Find Chat by App ID and Chat Number.
    chat_found = Chat.find_by(
      user_application_id: application_found.id,
      application_chat_number: chat_number
    )

    # 2.1 if not found, return error response.
    return Response.new(404, 'Chat not found.', {}) if chat_found.nil?

    # 3. Return chat found.
    Response.new(200, 'Chat found.', chat_found, %i[id user_application_id])
  end
end
