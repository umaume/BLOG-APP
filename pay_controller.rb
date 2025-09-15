# ※ ポストモデルです
class Post < ApplicationRecord
  enum status: { draft: 1, published: 2 }
end

# ※ ポストコントローラーです
class PostsController < ApplicationController
  def index
    @posts = Post.where("status = '#{params[:status]}'")
  end
end
