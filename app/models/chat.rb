# frozen_string_literal: true
class Chat < ApplicationRecord
  belongs_to :user_application, touch: true
  has_many :messages, dependent: :delete_all
end
