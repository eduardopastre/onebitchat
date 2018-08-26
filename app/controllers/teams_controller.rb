class TeamsController < ApplicationController
  before_action :set_team, only: [:destroy, :invite, :join]
  before_action :set_by_slug_team, only: [:show]

  def index
    @teams = current_user.teams
  end

  def show
    authorize! :read, @team
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to "/#{@team.slug}" }
      else
        format.html { redirect_to main_app.root_url, notice: @team.errors }
      end
    end
  end

  def destroy
    authorize! :destroy, @team
    @team.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def invite
    authorize! :invite, @team

    respond_to do |format|
      if @team_user.nil?
        UserMailer.invite(params[:team_user][:email], @team, current_user).deliver_now
        format.json { render json: 200, status: :created }
      else
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
    @team_user = TeamUser.new(team_id: @team.id, user_id: current_user.id)
    respond_to do |format|
      if @team_user.save
        format.html { redirect_to team_path(@team.slug) }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  private

  def set_by_slug_team
    @team = Team.find_by(slug: params[:slug])
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:slug).merge(user: current_user)
  end

  def verify_joined_team_user
    user = User.find_by(email: params[:team_user][:email])
    if !user.nil?
      @team_user = TeamUser.find_by(user_id: user.id, team_id: params[:id])
    end
  end
end
