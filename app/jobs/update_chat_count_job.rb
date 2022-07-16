# frozen_string_literal: true

# Job with the responsibility to queue the action to
# update the given application with the given chats_count in the database.
class UpdateChatCountJob < ApplicationJob
  # Set the Queue as Default
  queue_as :default

  def perform(app_id, new_count)
    # Update Application with new Chats count.
    if UserApplication.update(app_id, chats_count: new_count)
      true
    else
      throw ActiveRecord::RecordNotSaved
    end
  end
end
