# User Application Database Layer to check Cache for frequently looked tokens.
class UserApplicationDbService
  def initialize
    super
    @redis = Redis.new(:host => ENV["REDIS_HOST"], :port => ENV["REDIS_PORT"])
    begin
      @redis.ping

    rescue Redis::BaseConnectionError => e
      @redis = nil
      p "Redis Connection Error: #{e.message}"
    end
  end

  def find_app_by_token(application_token)
    return UserApplication.find_by_token(application_token) if @redis.nil?

    application = @redis.get(application_token)

    if application.nil?
      application = UserApplication.find_by_token(application_token)

      @redis.set(application_token, application.to_json, ex: 1.hours.to_s) unless application.nil?
    else
      application = JSON.parse(application, object_class: UserApplication)
    end

    application
  end
end
