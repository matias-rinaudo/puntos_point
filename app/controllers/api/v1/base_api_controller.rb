module Api
  module V1
    class BaseApiController < ActionController::Base
      before_filter :authenticate_request

      attr_reader :current_user

      private

      # Authenticate the request by verifying JWT token
      def authenticate_request
        header = request.headers['Authorization']

        # Log the Authorization header for debugging
        Rails.logger.debug("Authorization Header: #{header}")

        # Ensure the Authorization header is present and starts with 'Bearer '
        if header.present? && header.starts_with?('Bearer ')
          token = header.split(' ').last

          # Log the token to ensure it's correctly extracted
          Rails.logger.debug("Extracted Token: '#{token}'")

          # Guard against an empty token
          if token.blank?
            render json: { error: 'Token is missing' }, status: :unauthorized and return
          end

          # Decode the JWT token
          decoded = JsonWebToken.decode(token)

          if decoded
            @current_user = User.find_by(id: decoded[:user_id])
          else
            render json: { error: 'Invalid token' }, status: :unauthorized and return
          end
        else
          render json: { error: 'Missing or malformed token' }, status: :unauthorized and return
        end

        # Ensure the user is authenticated
        render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
      end
    end
  end
end
