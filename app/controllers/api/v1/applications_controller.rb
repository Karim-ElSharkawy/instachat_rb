# frozen_string_literal: true

module Api
  module V1
    # Controller for the User Applications Model.
    class ApplicationsController < ApplicationController

      before_action :initialize_instance_variables

      def initialize_instance_variables
        @application_service = ApplicationService.new
      end

      # Main Endpoints
      def create
        response = @application_service.create_new(application_name_param)
        render response.render_response
      end

      # Update Application by Token.
      def update
        response = @application_service.update_application_by_token(params[:token], application_name_param)
        render response.render_response
      end

      def show
        response = @application_service.show_application_by_token(params[:token])
        render response.render_response
      end

      private

      # Permit Checks.
      def application_name_param
        # Allow only name to be passed as token and chats_count is system-generated
        # and should not be made possible to alter from outside.
        params.require(:name)
        { name: params[:name] }
      end

    end
  end
end
