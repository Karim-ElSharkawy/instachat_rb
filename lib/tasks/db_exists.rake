namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue StandardError
      rake('db:create', 'db:migrate')
      exit 0
    else
      rake('db:migrate')
      exit 0
    end
  end
end

def rake(*tasks)
  tasks.each do |task|
    Rake.application[task].tap(&:invoke).tap(&:reenable)
    sleep(10)
  end
end