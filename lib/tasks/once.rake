namespace :once do
  desc "Task to change the user education field to empty array"
  task change_user_education: :environment do
      # my code goes here, this will loop through all user and make education an empty array
      User.all.each do | user |
          user.educations = []
          user.save
      end
      puts "Operation Done Successfully, thanks to Ibukun Muyide CTO at dropque" 
  end
end
