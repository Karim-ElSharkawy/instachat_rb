# Service Responsible for User Application Logic.
class ApplicationService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def create_new(application_params)
    SaveApplicationJob.perform_now(application_params[:name])
  end

  def update_application_by_token(token, new_params)
    UpdateApplicationJob.perform_now(token, new_params)
  end

  def show_application_by_token(token)
    user_application = @user_application_db_service.find_app_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if user_application.nil?

    Response.new(200, 'Application found.', user_application, [:id])
  end
end
