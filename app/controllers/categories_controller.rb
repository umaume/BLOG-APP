class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show ]

  def index
    @categories = Category.ordered.includes(:posts)
  end

  def show
    @posts = @category.posts.published.includes(:user, :likes, :comments, :tags).recent
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
