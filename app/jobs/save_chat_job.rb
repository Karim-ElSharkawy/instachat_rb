# frozen_string_literal: true

# Job with the responsibility to queue the action to
# insert a new chat.
class SaveChatJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def initialize(*arguments)
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def perform(application_token)
    # 1. Find application by token.
    user_application = @user_application_db_service.find_app_by_token(application_token)

    # 1.1 if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if user_application.nil?

    # 2. Create chat using application id and incrementing chat application-specific number.
    new_chat = Chat.create(
      user_application_id: user_application.id,
      application_chat_number: user_application.chats.count + 1
    )

    # Async
    UpdateChatCountJob.perform_later(user_application.id, new_chat.application_chat_number)

    # 3. Return Response based on the creation status.
    if new_chat.save
      Response.new(201, 'Chat created.', new_chat, %i[id user_application_id])
    else
      Response.new(500, 'Chat failed to be created.', new_chat.errors)
    end

  end
end
