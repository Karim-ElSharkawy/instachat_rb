class UpdateMessageJob < ApplicationJob
  queue_as :default

  def perform(message_obj, new_params)
    message_obj.with_lock do

      # Update Message and return new message on success.
      if Message.update(message_obj.id, new_params)
        message_obj.assign_attributes new_params
        Response.new(200, 'Message updated.', message_obj, %i[id chat_id])
      else
        throw ActiveRecord::RecordNotSaved
      end
    end
  end
end
