class ControlPanel::CompetitionsController < ApplicationController
  def update
    competition = Competition.find(params[:id])
    competition.update competition_params

    if competition.save
      flash[:success] = "Competition updated successfully."
    else
      flash[:error] = "There were an error while updating the competition."
    end

    redirect_to control_panel_root_url
  end

  private

  def competition_params
    params.require(:competition).permit(:open_donation)
  end
end
