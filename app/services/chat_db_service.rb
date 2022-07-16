# Chat Database Layer to check Cache for frequently looked tokens.
class ChatDbService
  def initialize
    super
    @redis = Redis.new
    @user_application_db_service = UserApplicationDbService.new
  end

  def find_chat(application_token, chat_number)
    user_application = @user_application_db_service.find_app_by_token(application_token)
    Chat.find_by(user_application_id: user_application.id, application_chat_number: chat_number) if @redis.nil?

    chat = @redis.get(chat_number)

    if application.nil?
      chat = Chat.find_by(user_application_id: user_application.id, application_chat_number: chat_number)
      @redis.set(chat_number, chat.to_json, ex: 1.hours.to_s)
    else
      chat = JSON.parse(chat, object_class: Chat)
    end

    chat
  end
end
