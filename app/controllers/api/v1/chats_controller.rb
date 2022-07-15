# frozen_string_literal: true

module Api
  module V1
    # Controller for the Chats Model.
    class ChatsController < ApplicationController

      before_action :initialize_instance_variables

      def initialize_instance_variables
        @chat_service = ChatService.new
      end

      # Main Endpoints
      def create
        response = @chat_service.create_new(params[:application_token])
        render response.render_response
      end

      # Update Application by Token.
      def update
        response = @chat_service.update_chat(
          params[:application_token],
          params[:chat_number],
          allowed_chat_params
        )
        render response.render_response
      end

      def destroy
        response = @chat_service.delete_chat(
          params[:application_token],
          params[:chat_number]
        )
        render response.render_response
      end

      def show
        response = @chat_service.show_chat(
          params[:application_token],
          params[:chat_number]
        )
        render response.render_response
      end

      private

      # Permit Checks.
      def allowed_chat_params
        # Currently, there is no field that needs to be updated in Chats. As they are all handled by the system
        # and it is not safe to allow all parameters to be updated at will.
        # params.require(:messages_count)
      end

    end
  end
end
