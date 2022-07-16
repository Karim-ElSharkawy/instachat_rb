# User Application Database Layer to check Cache for frequently looked tokens.
class UserApplicationDbService
  def initialize
    super
    @redis = Redis.new
  end

  def find_app_by_token(application_token)
    UserApplication.find_by_token(application_token) if @redis.nil?

    application = @redis.get(application_token)

    if application.nil?
      application = UserApplication.find_by_token(application_token)
      @redis.set(application_token, application.to_json)
    else
      application = JSON.parse(application, object_class: UserApplication)
    end

    application
  end
end
