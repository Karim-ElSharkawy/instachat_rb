# Chat Database Layer to check Cache for frequently looked tokens.
class ChatDbService
  def initialize
    super
    @redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
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

    return nil if user_application.nil?

    return FetchChatJob.perform_now(user_application.id, chat_number) if @redis.nil?

    chat = @redis.get("#{application_token}_chat_#{chat_number}")

    if chat.nil?
      chat = FetchChatJob.perform_now(user_application.id, chat_number)

      @redis.set("#{application_token}_chat_#{chat_number}", chat.to_json, ex: 1.hours.to_s) unless chat.nil?
    else
      chat = JSON.parse(chat, object_class: Chat)
    end

    chat
  end

  def save_chat_by_token(application_token, chat_obj)
    return if @redis.nil?

    @redis.set("#{application_token}_chat_#{chat_obj.application_chat_number}", chat_obj.to_json, ex: 1.hours.to_s)
  end
end
