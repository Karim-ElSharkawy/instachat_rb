# frozen_string_literal: true

module Api
  module V1
    # Controller for the Chats Model.
    class MessagesController < ApplicationController

      before_action :initialize_instance_variables

      def initialize_instance_variables
        @message_service = MessageService.new
      end

      # Main Endpoints
      def create
        response = @message_service.create_new(
          params[:application_token],
          params[:chat_number],
          allowed_message_params[:text]
        )
        render response.render_response
      end

      # Update Application by Token.
      def update
        response = @message_service.update_message(
          params[:application_token],
          params[:chat_number],
          params[:number],
          allowed_message_params
        )
        render response.render_response
      end

      def show
        response = @message_service.show_message(
          params[:application_token],
          params[:chat_number],
          params[:number]
        )
        render response.render_response
      end

      def search
        response = @message_service.search(
          params[:application_token],
          params[:chat_number],
          params[:text]
        )
        render response.render_response
      end

      private

      # Permit Checks.
      def allowed_message_params
        # Only allow message value in body.
        params.require(:text)
        { text: params[:text] }
      end

    end
  end
end
