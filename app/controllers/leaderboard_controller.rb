class LeaderboardController < ApplicationController
  layout false

  def show
  end

  def data
    render :data, format: :json
  end
end
