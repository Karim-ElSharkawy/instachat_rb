# frozen_string_literal: true

# Job with the responsibility to queue the action to
# insert a new chat. This is made to be a sync job.
class SaveApplicationJob < ApplicationJob
  queue_as :default

  def perform(application_name)
    # 1. Create Application with given application name and generate UUID as token.
    application = UserApplication.create(name: application_name, token: SecureRandom.uuid)

    # 2. Return Response based on the creation status.
    if application.save
      Response.new(201, 'Application created.', application, [:id])
    else
      Response.new(500, 'Application failed to be created.', application.errors)
    end
  end
end
