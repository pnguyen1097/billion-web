json.competition @competition

json.projects do
  json.array! @competition.projects.with_rank do |project|
    json.extract! project, :name, :rank
  end
end
