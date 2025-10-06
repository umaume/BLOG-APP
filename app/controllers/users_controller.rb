class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_user, only: [ :show, :edit, :update ]
  before_action :check_owner, only: [ :edit, :update ]

  def show
    @posts = @user.posts.published.recent.page(params[:page]).per(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :name, :bio, :website, :avatar ])
  end

  def check_owner
    redirect_to root_path, alert: 'Not authorized to perform this action.' unless @user == current_user
  end
end
