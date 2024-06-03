class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # Rescue from not found error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :author)
  end

  def record_not_found
    flash[:alert] = 'The post you were looking for could not be found.'
    redirect_to posts_path
  end
end