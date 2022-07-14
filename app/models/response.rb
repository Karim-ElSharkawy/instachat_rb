# frozen_string_literal: true

# General Response Class to be used to return a suitable response from services.
class Response
  def initialize(status_code, message, payload)
    @status_code = status_code
    @message = message
    @payload = payload

    @status_message = if status_code < 300 && status_code >= 200
                        'SUCCESS'
                      else
                        'FAILURE'
                      end
  end

  def render_response
    { json: {
        status: @status_message,
        message: @message,
        data: @payload
      },
      except: [:id],
      status: @status_code
    }
  end
end
