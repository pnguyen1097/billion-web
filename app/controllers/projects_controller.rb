class ProjectsController < ApplicationController
  def show
    @project = @competition.projects.friendly.find params[:id]
  end

  def index
    @projects = @competition.projects.with_rank
  end
end
