# Model for Message. This model also serves as the elasticsearch model with the ability to search.
class Message < ApplicationRecord
  include MessageSearchable
  belongs_to :chat, touch: true

  def self.search(query_text, chat_id)
    __elasticsearch__.client = Elasticsearch::Client.new transport_options: {
      request: { timeout: 10 }
    }
    return nil if __elasticsearch__.client.ping == false

    result = __elasticsearch__.search(
      {
        query: {
          "bool": {
            "must": [
              {
                "match": {
                  "chat_id": chat_id
                }
              },
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

