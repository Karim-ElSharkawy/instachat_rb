class FetchUserApplicationJob < ApplicationJob
  queue_as :default

  def perform(application_token)
    UserApplication.find_by_token(application_token)
  end
end
