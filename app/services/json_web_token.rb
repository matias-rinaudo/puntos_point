class JsonWebToken
  SECRET_KEY = '75df9c7618070bb52d6b9d65d2a806f8f1ba7392d150ca914974907692e66e83469fac7ce7e15a00f67db0fee84d088a505e70e39faec395e7649690de8741e4'

  # Encode a JWT token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode a JWT token
  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    nil
  end
end
