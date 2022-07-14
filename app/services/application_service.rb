# Service Responsible for User Application Logic.
class ApplicationService

  def create_new(application_name)
    # 1. Create Application with given application name and generate UUID as token.
    application = UserApplication.create(name: application_name, token: SecureRandom.uuid)

    # 2. Return Response based on the creation status.
    if application.save
      Response.new(201, 'Application created.', application)
    else
      Response.new(500, 'Application failed to be created.', application.errors)
    end
  end

  def update_application_by_token(token, new_application_name)
    # Find Application by Token.
    application_to_be_updated = UserApplication.find_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_to_be_updated.nil?

    # Lock on record before updating.
    application_to_be_updated.with_lock do

      # Update Application and return new application on success.
      if UserApplication.update(application_to_be_updated.id, name: new_application_name)
        application_to_be_updated.name = new_application_name
        Response.new(200, 'Application updated.', application_to_be_updated)
      else
        Response.new(500, 'Application failed to be updated.', {})
      end
    end
  end

  def destroy_application_by_token(token)
    application_to_be_deleted = UserApplication.find_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_to_be_deleted.nil?

    if UserApplication.destroy(application_to_be_deleted.id)
      Response.new(200, 'Application deleted.', application_to_be_deleted)
    else
      Response.new(500, 'Application failed to be deleted.', {})
    end
  end

  def show_application_by_token(token)
    user_application = UserApplication.find_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if user_application.nil?

    Response.new(201, 'Application found.', user_application)
  end
end
