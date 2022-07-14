# frozen_string_literal: true

# Base Controller Class for all Controllers that include error handling and common functionalities.
class ApplicationController < ActionController::API
  # Error Handling Redirections.
  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ::ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ::NameError, with: :error_occurred
  rescue_from ::ActionController::RoutingError, with: :error_occurred

  protected

  # Error Handling Methods.
  def record_not_found(exception)
    render json: { status: 'FAILURE', message: exception.message }.to_json, status: 404
  end

  def parameter_missing(exception)
    render json: { status: 'FAILURE', message: exception.message }.to_json, status: 400
  end

  def error_occurred(exception)
    render json: { status: 'FAILURE', message: exception.message }.to_json, status: 500
  end
end
