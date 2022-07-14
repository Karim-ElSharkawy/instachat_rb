# frozen_string_literal: true

module Api
  module V1
    # Controller for the Chats Model.
    class ChatsController < ApplicationController
      # Error Handling Redirections.
      rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ::ActionController::ParameterMissing, with: :parameter_missing
      rescue_from ::NameError, with: :error_occurred
      rescue_from ::ActionController::RoutingError, with: :error_occurred

      # Main Endpoints
      def create
        @application = UserApplication.create(name: user_application_params[:name], token: SecureRandom.uuid)

        if @application.save
          render json: { status: 'SUCCESS', message: 'Application created.', data: @application },
                 except: [:id],
                 status: :created
        else
          render json: { status: 'Failure', message: 'Application failed to be created.', data: @application.errors },
                 except: [:id],
                 status: :unprocessable_entity
        end
      end

      def update
        @application = UserApplication.update(params[:id], name: user_application_params)

        if @application.save
          render json: { status: 'SUCCESS', message: 'Application created.', data: @application },
                 except: [:id],
                 status: :created
        else
          render json: { status: 'Failure', message: 'Application failed to be created.', data: @application.errors },
                 except: [:id],
                 status: :unprocessable_entity
        end
      end

      def show
        @user_application = UserApplication.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Application found.', data: @user_application }, except: [:id],
               status: :ok
      end

      private

      # Permit Checks.
      def user_application_params
        params.require(:name)
      end

    end
  end
end
