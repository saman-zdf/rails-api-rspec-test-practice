class AuthController < ApplicationController

  def login 
    # for log in we can user find_by to find a user by email, and use your auth_params to get the email
    user = User.find_by(email: auth_params[:email])
    # this is a shorthand of puttin user && user.authenticate
    if user&.authenticate(auth_params[:password])
      token = JwtService.encode(user)
      # now we can render our token and user name 
      render json: {jwt: token, username: user.username}, status: 200
    else
      # if the user does not exist we need to render error msg
      render json: {error: "Incorrect credentials!!!"}, status: 422
    end
  end

  def register
    user = User.create(auth_params)
    unless user.errors.any? 
      token = JwtService.encode(user)
      render json: {jwt: token, username: user.username}, status: 201
    else
      render json: {error: user.errors.full_messages}, status: 422
    end
  end

  private
    def auth_params
      params.require(:auth).permit( :email, :password, :password_confirmation, :username)
    end
end
