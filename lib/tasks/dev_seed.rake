namespace :dev_seed do
  task all: [:competition, :projects, :transactions] do
  end

  desc 'Add seed competition'
  task competition: :environment do
    FactoryGirl.create :competition, start_date: Date.today - 10.day, end_date: Date.today + 30.day
  end

  desc 'Add seed projects'
  task projects: :environment do
    FactoryGirl.create_list :project, 19, :with_collaborators, competition: Competition.first
  end

  desc 'Add seed transactions'
  task transactions: :environment do
    Project.where(eliminated_at: nil).each do |project|
      temp_user = FactoryGirl.create :temp_user

      rand(10..20).times do
        dollar_to_point = Competition.first.dollar_to_point
        amount = rand(1.0..20.0).round(2)
        points = (amount * dollar_to_point).ceil

        Transaction.create(recipient: temp_user, amount: amount,
                           points: points, competition: Competition.first)

        Transaction.create(recipient: project, sender: temp_user,
                           points: points, competition: Competition.first)
      end
    end
  end
end
