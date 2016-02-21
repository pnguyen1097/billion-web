namespace :eliminate do
  task pitch: :environment do
    number_to_advance = 1
    competition = Competition.first
    projects = competition.projects.sort_by { |p| 0 - p.points_donated }

    eliminated = projects[number_to_advance..-1]

    eliminated.each { |p| p.update eliminated_at: DateTime.now }
  end
end
