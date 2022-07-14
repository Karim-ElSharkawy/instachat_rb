# Model
class UserApplication < ApplicationRecord
  has_many :chats, dependent: :delete_all

  validates :name, length: {
    maximum: 255,
    minimum: 5,
    tokenizer: ->(str) { str.scan(/\w+/) }
  }

  def self.featured
    where.not(id: nil).sample
  end
end
