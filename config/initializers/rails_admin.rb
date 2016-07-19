RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.navigation_static_links = {
    'Control Panel' => 'control_panel'
  }

  # Authorization with pundit policies
  config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.included_models = %w(User TempUser Role Membership Project Transaction
                              Competition Membership Round Match)

  config.model 'Transaction' do
    edit do
      field :amount
      field :recipient
      field :points
      field :competition
    end
  end

  config.model 'User' do
    edit do
      field :email
      field :password
      field :first_name
      field :last_name
      field :bio, :text
      field :profile_image_url
    end
  end

  config.model 'Project' do
    edit do
      field :name
      field :blurb, :text
      field :description, :text
      field :competition
      field :video_url
      field :card_image_url
      field :project_image_url
      field :collaborators
      field :sent_transactions
      field :received_transactions
      field :short_name
      field :wine
    end
  end
end
