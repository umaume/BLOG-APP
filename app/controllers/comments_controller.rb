class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :check_owner, only: [ :edit, :update, :destroy ]

  def edit
  end
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post, notice: 'コメントを投稿しました。' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html {
          @comments = @post.comments.recent.includes(:user)
          render 'posts/show', status: :unprocessable_entity
        }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace('comment-form-container',
            partial: 'comments/form', locals: { post: @post, comment: @comment })
        }
      end
    end
  end


  def update
    if @comment.update(comment_params)
      redirect_to @post, notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.expect(comment: [ :body ])
  end

  def check_owner
    redirect_to @post, alert: 'Not authorized to perform this action.' unless @comment.user == current_user
  end
end
