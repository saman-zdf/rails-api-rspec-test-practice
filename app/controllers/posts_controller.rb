class PostsController < ApplicationController
  before_action :authenticate, only: [:create, :update, :destroy]

  before_action :set_post, only: [:show]

  def index 
    posts = Post.all.includes(:author, :category)
    render json: posts, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  def show 
    render json: @post, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  def create
    post = current_user.posts.create(post_params)
    unless post.errors.any? 
      render json: post, include: {author: {only: :username}, category: {only: :name}}, status: 201
    else
      render json: {error: post.errors.full_messages}, status: 422
    end
  end

  private
    def set_post
      begin
        @post = Post.find(params[:id])
      rescue 
        render json: {error: "Unable to find post."}, status: 404
      end
    end

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :user_id)
    end
end
