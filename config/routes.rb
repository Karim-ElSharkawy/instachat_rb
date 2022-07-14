Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :applications, param: :token, only: %i[create update destroy show] do
        resources :chats,
                  param: :chat_number,
                  only: %i[create update destroy show]
      end
    end
  end
end
