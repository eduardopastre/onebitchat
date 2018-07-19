class TeamUsersController < ApplicationController
  before_action :set_team_user, only: [:destroy]
  before_action :verify_joined_team_user, only: [:invite]

  def create
    @team_user = TeamUser.new(team_user_params)
    authorize! :create, @team_user

    UserMailer.invite(@team_user.user.email, @team_user.team, current_user).deliver_now

    respond_to do |format|
      #if @team_user.save
        format.json { render :show, status: :created }
      #else
      #  format.json { render json: @team_user.errors, status: :unprocessable_entity }
      #end
    end
  end

  def destroy
    authorize! :destroy, @team_user
    @team_user.destroy

    respond_to do |format|
      format.json { render json: true }
    end
  end

  def invite
    authorize! :invite, @current_team_user

    puts "------ AUTORIZED"

    respond_to do |format|
      if @team_user.nil?
        UserMailer.invite(params[:team_user][:email], @current_team_user.team, current_user).deliver_now
        format.json { render :show, status: :created }
      else
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_team_user
    @team_user = TeamUser.find_by(params[:user_id], params[:team_id])
  end

  def team_user_params
    user = User.find_by(email: params[:team_user][:email])
    params.require(:team_user).permit(:team_id).merge(user_id: user.id)
  end

  def verify_joined_team_user
    @current_team_user = TeamUser.find_by(user_id: current_user.id, team_id: params[:team_user][:team_id])
    user = User.find_by(email: params[:team_user][:email])
    if !user.nil?
      @team_user = TeamUser.find_by(user_id: user.id, team_id:  params[:team_user][:team_id])
    end
  end
end
