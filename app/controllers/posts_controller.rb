class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate, only: [:create, :update, :destroy]
  before_action :authorize, only: [:update, :destroy]

  def index 
    posts = Post.all.includes(:author, :category)
    render json: posts, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  def show 
    render json: @post, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  def create
    post = current_user.posts.create(post_params)
    render_post(post)
  end

  def update 
    @post.update(post_params)
    render_post(@post)
  end

  def destroy 
    attributes = @post.attributes
    @post.destroy
    render json: attributes, status: 202
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

    def authorize 
      render json: {error: "You don't have permission to do that"}, status: 401 unless current_user.id == @post.user_id
    end

    def render_post(post)
      unless post.errors.any? 
        render json: post, include: {author: {only: :username}, category: {only: :name}}, status: 201
      else
        render json: {error: post.errors.full_messages}, status: 422
      end
    end
end
