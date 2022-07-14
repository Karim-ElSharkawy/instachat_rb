if UserApplication.any?
  Chat.delete_all
  UserApplication.delete_all
end

15.times do

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
