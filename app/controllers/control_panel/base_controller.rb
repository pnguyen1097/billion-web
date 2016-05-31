class ControlPanel::BaseController < ApplicationController
  before_action :authenticate_user!
  # TODO: Pundit policies?
  before_action :ensure_admin


  private

  def ensure_admin
    raise Pundit::NotAuthorizedError unless user_signed_in? && current_user.admin?
  end
end
