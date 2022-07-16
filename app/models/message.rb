class Message < ApplicationRecord
  belongs_to :chat, touch: true
end
