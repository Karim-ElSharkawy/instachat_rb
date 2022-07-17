module MessageSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      # mapping definition goes here
      indexes :text, type: :text, analyzer: 'english'
      indexes :id, analyzer: 'english'
    end

    def self.search(query)
      # build and run search
    end
  end
end
