FactoryGirl.define do
  factory :project do
    name { Faker::Company.name }
    short_name { name.parameterize }
    blurb { Faker::Lorem.paragraph }
    description do
      [
        "# #{Faker::Lorem.sentence}",
        "#{Faker::Lorem.paragraph(5)}",
      ].join("\n\n")
    end
    card_image_url 'http://lorempixel.com/400/200/business'
    project_image_url 'http://lorempixel.com/1800/1200/business'
    competition

    trait :with_comments do
      after(:build, :stub) do |project|
        create_list(:comment, 2, project: project)
      end
    end

    trait :with_collaborators do
      after(:build, :stub) do |project|
        create_list(:membership, 3, project: project)
      end
    end
  end
end
