class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: %i[ show edit update destroy like unlike ]
  before_action :check_owner, only: %i[ edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.published.includes(:user, :likes, :comments, :category, :tags)
    @categories = Category.order(:name)
    @popular_tags = Tag.popular.limit(10)

    # Search functionality
    if params[:search].present?
      @posts = @posts.search_by_content(params[:search])
    end

    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
    end

    if params[:tag_id].present?
      @posts = @posts.joins(:tags).where(tags: { id: params[:tag_id] })
    end

    @posts = @posts.order(created_at: :desc)
  end

  def timeline
    if user_signed_in?
      # Get posts from users the current user is following, plus their own posts
      following_ids = current_user.following.pluck(:id)
      @posts = Post.published
                   .includes(:user, :likes, :comments)
                   .where(user_id: [ following_ids + [ current_user.id ] ].flatten)
                   .order(created_at: :desc)
    else
      redirect_to posts_path
    end
  end

  def search
    @search_query = params[:q]
    @category_filter = params[:category_id]
    @tag_filter = params[:tag_id]

    @posts = Post.published.includes(:user, :likes, :comments, :category, :tags)
    @categories = Category.order(:name)
    @tags = Tag.order(:name)

    if @search_query.present?
      @posts = @posts.search_by_content(@search_query)
    end

    if @category_filter.present?
      @posts = @posts.where(category_id: @category_filter)
    end

    if @tag_filter.present?
      @posts = @posts.joins(:tags).where(tags: { id: @tag_filter })
    end

    @posts = @posts.order(created_at: :desc)

    render :index
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = @post.comments.build
    @comments = @post.comments.recent.includes(:user)
  end

  # GET /posts/new
  def new
    @post = Post.new
    @categories = Category.ordered
  end

  # GET /posts/1/edit
  def edit
    @categories = Category.ordered
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        @categories = Category.ordered
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        @categories = Category.ordered
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /posts/1/like
  def like
    @like = @post.likes.find_or_initialize_by(user: current_user)

    if @like.persisted?
      redirect_to @post, alert: 'すでにいいねしています。'
    else
      if @like.save
        respond_to do |format|
          format.html { redirect_to @post, notice: 'いいねしました。' }
          format.turbo_stream
        end
      else
        redirect_to @post, alert: 'いいねに失敗しました。'
      end
    end
  end

  # DELETE /posts/1/unlike
  def unlike
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.html { redirect_to @post, notice: 'いいねを取り消しました。' }
        format.turbo_stream { render :like }
      end
    else
      redirect_to @post, alert: 'いいねの取り消しに失敗しました。'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by!(slug: params[:id]) || Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :content, :published, :category_id, :tag_names, images: [] ])
    end

    def check_owner
      redirect_to posts_path, alert: 'Not authorized to perform this action.' unless @post.user == current_user
    end
end
