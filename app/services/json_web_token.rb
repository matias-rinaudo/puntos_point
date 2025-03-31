class JsonWebToken
  SECRET_KEY = '75df9c7618070bb52d6b9d65d2a806f8f1ba7392d150ca914974907692e66e83469fac7ce7e15a00f67db0fee84d088a505e70e39faec395e7649690de8741e4'

  def self.encode(payload, exp = 24 * 3600)
    Rails.logger.info "#{payload}"
    payload[:exp] = (Time.now.to_i + exp).to_i
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    body, = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
    
    if body.is_a?(Hash)
      body['exp'] = body['exp'].to_i if body['exp']
      return HashWithIndifferentAccess.new(body)
    end

    nil
  rescue JWT::ExpiredSignature
    Rails.logger.error 'Token has expired'
    nil
  rescue JWT::DecodeError => e
    Rails.logger.error "Failed to decode token: #{e.message}"
    nil
  end
end
