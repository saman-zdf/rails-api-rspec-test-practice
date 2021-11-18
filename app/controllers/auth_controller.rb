class AuthController < ApplicationController

  def login 
    # for log in we can user find_by to find a user by email, and use your auth_params to get the email
    user = User.find_by(email: auth_params[:email])
    # this is a shorthand of puttin user && user.authenticate
    if user&.authenticate(auth_params[:password])
      # we need to create a payload which need user id coming form the user we find nad expiry to set time for it
      payload = {user_id: user.id, exp: 1.hour.from_now.to_i}
      # when we create token we should pass JWT.encode and pass the payload and Rails.application.credentials.dig(:secret_key_base) to keep our token as secret
      token = JWT.encode(payload, Rails.application.credentials.dig(:secret_key_base))
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
      payload = {user_id: user.id, exp: 1.hour.from_now.to_i}
      token = JWT.encode(payload, Rails.application.credentials.dig(:secret_key_base))
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
