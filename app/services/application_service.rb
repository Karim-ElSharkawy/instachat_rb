# Service Responsible for User Application Logic.
class ApplicationService

  def initialize
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def create_new(application_params)
    # 1. Create Application with given application name and generate UUID as token.
    application = UserApplication.create(name: application_params[:name], token: SecureRandom.uuid)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application.nil?

    # 2. Return Response based on the creation status.
    if application.save
      Response.new(201, 'Application created.', application, [:id])
    else
      Response.new(500, 'Application failed to be created.', application.errors)
    end
  end

  def update_application_by_token(token, new_application_params)
    # Find Application by Token.
    application_to_be_updated = @user_application_db_service.find_app_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_to_be_updated.nil?

    # Lock on record before updating.
    application_to_be_updated.with_lock do

      # Update Application and return new application on success.
      if UserApplication.update(application_to_be_updated.id, new_application_params)
        application_to_be_updated.name = new_application_params[:name]
        Response.new(200, 'Application updated.', application_to_be_updated, [:id])
      else
        Response.new(500, 'Application failed to be updated.', {})
      end
    end
  end

  def show_application_by_token(token)
    user_application = @user_application_db_service.find_app_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if user_application.nil?

    Response.new(200, 'Application found.', user_application, [:id])
  end
end
