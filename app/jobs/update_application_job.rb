class UpdateApplicationJob < ApplicationJob
  queue_as :default

  def initialize(*arguments)
    super
    @user_application_db_service = UserApplicationDbService.new
  end

  def perform(token, new_params)
    # Find Application by Token.
    application_to_be_updated = @user_application_db_service.find_app_by_token(token)

    # if not found, return error response.
    return Response.new(404, 'Application not found.', {}) if application_to_be_updated.nil?

    # Lock on record before updating.
    application_to_be_updated.with_lock do

      # Update Application and return new application on success.
      if UserApplication.update(application_to_be_updated.id, new_params)
        application_to_be_updated.assign_attributes new_params
        @user_application_db_service.save_app_by_token(token, application_to_be_updated)
        Response.new(200, 'Application updated.', application_to_be_updated, [:id])
      else
        Response.new(500, 'Application failed to be updated.', {})
      end
    end
  end
end
