Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :applications, param: :token, only: %i[create update show] do
        resources :chats,
                  param: :number,
                  only: %i[create update show] do
          resources :messages,
                    param: :number,
                    only: %i[create update show]
        end
      end
    end
  end
end
