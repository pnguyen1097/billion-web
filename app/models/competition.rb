class Competition < ActiveRecord::Base
  has_many :projects, inverse_of: :competition, dependent: :destroy
  has_many :transactions, inverse_of: :competition, dependent: :destroy
  has_many :rounds, inverse_of: :competition, dependent: :destroy

  # TODO: Add validations to ensure only 1 competition per time period
  # TODO: validate that end_date > start_date
  validates :code_name, :start_date, :end_date, presence: true

  validates :dollar_to_point, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  # TODO: spec
  def has_winner?
    projects.where(eliminated_at: nil).count == 1
  end

  def winner
    projects.find_by(eliminated_at: nil) if has_winner?
  end

  # TODO: Opportunity for null object?
  def self.current_competition
    find_by('start_date <= :now and end_date > :now', now: Time.now)
  end

  # TODO: Opportunity for null object?
  def active_round
    rounds.find_by('started_at < :now and ended_at > :now', now: Time.now)
  end

  def total_raised
    projects_net_total = projects.select('projects.*, (SUM(coalesce(received.points, 0)) - SUM(coalesce(sent.points, 0))) AS net_total')
      .joins("LEFT OUTER JOIN transactions AS received ON received.recipient_type = 'Project' AND received.recipient_id = projects.id")
      .joins("LEFT OUTER JOIN transactions AS sent ON sent.sender_type = 'Project' AND sent.sender_id = projects.id")
      .where(wine: false)
      .group('projects.id')
    projects_net_total.reduce(0) { |m, p| m + p.net_total } / dollar_to_point.to_f
  end

end
