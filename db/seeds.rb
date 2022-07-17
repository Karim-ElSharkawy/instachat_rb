# frozen_string_literal: true
return unless Rails.env.development?

30.times do

  UserApplication.create(
    {
      token: SecureRandom.uuid,
      name: Faker::App.name
    }
  )
end

applications = UserApplication.all

applications.length.times do
  application = applications.featured

  app_chats = Chat.joins(:user_application).where(
    user_application_id: application.id
  )

  length_var = app_chats.length + 1

  Chat.create({
                application_chat_number: length_var,
                user_application_id: application.id
              })
end

Chat.all.each do |chat|
  15.times do
    Message.create(
      text: Faker::Quote.most_interesting_man_in_the_world,
      chat_id: chat.id,
      chat_message_number: chat.messages.count + 1
    )
  end
end
