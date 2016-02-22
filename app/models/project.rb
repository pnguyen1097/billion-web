class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name, use: :slugged

  belongs_to :competition, inverse_of: :projects
  has_many :memberships, inverse_of: :project, dependent: :destroy
  has_many :collaborators, through: :memberships, source: :user
  has_many :comments, inverse_of: :project, dependent: :destroy
  has_many :sent_transactions, as: :sender, class_name: 'Transaction'
  has_many :received_transactions, as: :recipient, class_name: 'Transaction'
  has_many :matches_as_1, class_name: 'Match', foreign_key: :project_1_id,
                          inverse_of: :project_1
  has_many :matches_as_2, class_name: 'Match', foreign_key: :project_2_id,
                          inverse_of: :project_2

  validates :name, presence: true

  # TODO: spec for scopes

  scope :active, -> { where(eliminated_at: nil) }

  scope :order_by_points, lambda {
    select('projects.*, sum(points) as total_points')
      .joins('LEFT JOIN transactions ON projects.id = transactions.recipient_id and transactions.recipient_type = \'Project\'')
      .order('total_points DESC NULLS LAST')
      .group('projects.id')
  }

  # Use Postgres rank() to add a ranks attribute to each project in a
  # collection.
  #
  # This gives you the ranks within the projects it is called on, so to get
  # rank for a competition, this must be called on the collection of all
  # projects in the competition.
  #
  # This returns an array, not a relation!
  # TODO: add spec
  def self.with_rank
    find_by_sql("SELECT *, rank() over (order by total_points DESC NULLS LAST, random()) FROM (#{order_by_points.to_sql}) AS temp")
  end

  # TODO: There is a better way to do this. This makes me sad.
  def current_competitor
    match = competition.active_round.try(:matches)
            .try(:where, 'project_1_id = :id OR project_2_id = :id', id: id)
            .try(:first)

    match.project_1_id == id ? match.project_2 : match.project_1 unless match.nil?
  end

  def points_donated
    received_transactions.sum(:points)
  end

  def donation_count
    received_transactions.size
  end

  def points_per_donation
    return 0 if donation_count == 0
    points_donated / donation_count
  end

  def eliminated?
    eliminated_at.present?
  end
end
