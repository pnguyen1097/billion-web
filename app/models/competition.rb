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
    transactions.where('sender_id IS NULL').sum(:amount)
  end
end
