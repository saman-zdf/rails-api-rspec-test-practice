class PostsController < ApplicationController
  def index 
    posts = Post.all.includes(:author, :category)
    render json: posts, include: {author: {only: :username}, category: {only: :name}}, status: 200
  end
end
