class ControlPanel::DashboardController < ApplicationController
  def index
    @competition = Competition.current_competition
    @projects = @competition.projects.active
    # Recent transactions that were made directly to a project
    @recent_transactions = @competition.transactions
      .where(sender_id: nil, recipient_type: 'Project')
      .order('created_at DESC')
      .limit(10)
  end
end
