require 'yaml'

desc 'Import competition yaml file.'
task :import, [:path] => :environment do |t, args|
  ActiveRecord::Base.transaction do
    puts "Loading #{args.path}..."
    data = YAML.load_file(args.path)

    puts "Creating competition..."
    competition = Competition.new data['competition']

    puts competition.inspect
    unless competition.valid?
      puts "Competition not valid."
      puts competition.errors.full_messages
      fail
    end

    competition.save!
    puts "Competition created"

    puts "Creating projects..."
    projects_data = data['projects'] || []

    if projects_data.empty?
      puts "WARN: no project present."
    end

    projects_data.each.with_index do |project_attrs, i|
      project = Project.new(project_attrs.merge(competition_id: competition.id))
      puts "Project #{i}"
      puts project.inspect
      unless project.valid?
        puts "Project #{i}: #{project_attrs[:name]} is not valid"
        puts project.errors.full_messages
        fail
      end

      project.save!
      puts
    end
  end
end
