class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    if current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user, notice: "You are now following #{@user.display_name}." }
        format.turbo_stream
      end
    else
      redirect_to @user, alert: 'Unable to follow this user.'
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user, notice: "You are no longer following #{@user.display_name}." }
      format.turbo_stream { render :create }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
