class Message < ApplicationRecord
  include MessageSearchable
  belongs_to :chat, touch: true

  def self.search(query_text, chat_id)
    result = __elasticsearch__.search(
      {
        query: {
          "bool": {
            "must": [
              {
                wildcard: {
                  "text": {
                    "value": "*#{query_text}*"
                  }
                }
              }
            ]
          }
        }
      }
    )
    result.records
  end
end

