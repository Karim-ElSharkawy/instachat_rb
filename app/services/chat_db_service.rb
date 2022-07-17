# Chat Database Layer to check Cache for frequently looked tokens.
class ChatDbService
  def initialize
    super
    @redis = Redis.new
    begin
      @redis.ping

    rescue Redis::BaseConnectionError => e
      @redis = nil
      p "Redis Connection Error: #{e.message}"
    end

    @user_application_db_service = UserApplicationDbService.new
  end

  def find_chat(application_token, chat_number)
    user_application = @user_application_db_service.find_app_by_token(application_token)

    Chat.find_by(user_application_id: user_application.id, application_chat_number: chat_number) if @redis.nil?
    return nil if user_application.nil?

    chat = @redis.get("#{application_token}_chat_#{chat_number}")

    if chat.nil?
      chat = Chat.find_by(user_application_id: user_application.id, application_chat_number: chat_number)

      @redis.set("#{application_token}_chat_#{chat_number}", chat.to_json, ex: 1.hours.to_s) unless chat.nil?
    else
      chat = JSON.parse(chat, object_class: Chat)
    end

    chat
  end
end
