# its conventional to have the name of the .rake file and the namespace match
namespace :daily do
    desc 'send notification and email to recruiters daily'
    task send_notification_to_recruiters: :environment do
      # ... set options if any
      puts "working like charms"
    end
end
