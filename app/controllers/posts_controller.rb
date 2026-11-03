class PostsController < ApplicationController
  before_action :authenticate_user!,
                only: [:new, :create, :edit, :update, :destroy]

  before_action :set_post,
                only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)

    if params[:query].present?
      @posts = @posts.where(
        "title ILIKE ?",
        "%#{Post.sanitize_sql_like(params[:query])}%"
      )
    end
  end

  def show
  end

  def new
    @post = current_user.posts.build
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      respond_to do |format|
        format.html do
          redirect_to @post, notice: "Post created successfully."
        end

        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post

    @post.destroy

    respond_to do |format|
      format.html do
        redirect_to posts_path, notice: "Post deleted successfully."
      end

      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end