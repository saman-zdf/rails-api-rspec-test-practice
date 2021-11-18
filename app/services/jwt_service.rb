class JwtService 

  @secret = Rails.application.credentials.dig(:secret_key_base)

  def self.encode(user) 
    # we need to create a payload which need user id coming form the user we find nad expiry to set time for it
    payload = {user_id: user.id, exp: 1.hour.from_now.to_i}
    # when we create token we should pass JWT.encode and pass the payload and Rails.application.credentials.dig(:secret_key_base) to keep our token as secret which we pass the instance of @secret instead
    token = JWT.encode(payload, @secret)
  end

  def self.decode(toke) 

  end
end