class PostsController < ApplicationController

  before_action :set_post, only: [:show]

  def index 
    posts = Post.all.includes(:author, :category)
    render json: posts, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  def show 
    render json: @post, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end

  private
    def set_post
      begin
        @post = Post.find(params[:id])
      rescue 
        render json: {error: "Unable to find post."}, status: 404
      end
    end
end
