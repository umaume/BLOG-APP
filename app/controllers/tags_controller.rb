class TagsController < ApplicationController
  before_action :set_tag, only: [ :show ]

  def index
    @tags = Tag.ordered.includes(:posts)
  end

  def show
    @posts = @tag.posts.published.includes(:user, :likes, :comments, :category).recent
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
