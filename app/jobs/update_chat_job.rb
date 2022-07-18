class UpdateChatJob < ApplicationJob
  queue_as :default

  def initialize(*arguments)
    super
    @chat_db_service = ChatDbService.new
  end

  def perform(application_token, chat_obj, new_params)
    chat_obj.with_lock do

      # Update Chat and return new chat on success.
      if Chat.update(chat_obj.id, new_params)
        chat_obj.assign_attributes new_params
        @chat_db_service.save_chat_by_token(application_token, chat_obj)
        Response.new(200, 'Chat updated.', chat_obj, %i[id user_application_id])
      else
        throw ActiveRecord::RecordNotSaved
      end
    end
  end
end
