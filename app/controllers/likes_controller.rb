class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.turbo_stream
      end
    else
      redirect_to @post, alert: 'Unable to like this post.'
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy

    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream { render :create }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
