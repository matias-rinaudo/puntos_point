module Api
  module V1
    class BaseApiController < ActionController::Base
      before_filter :authenticate_request

      attr_reader :current_user

      private

      def authenticate_request
        header = request.headers['Authorization']
        Rails.logger.info "Extracted Token: #{header}"  # DEBUG

        if header.blank?
          Rails.logger.error 'Missing Authorization header'
          render json: { error: 'Missing token' }, status: :unauthorized and return
        end

        token = header.split(' ').last
        Rails.logger.info "Token: #{token}"  # DEBUG

        if token.blank?
          Rails.logger.error 'Token is missing'
          render json: { error: 'Invalid token' }, status: :unauthorized and return
        end

        decoded_token = JsonWebToken.decode(token)
        Rails.logger.info "Decoded Token: #{decoded_token.inspect}"  # DEBUG

        if decoded_token.nil? || decoded_token['user_id'].nil?
          Rails.logger.error 'Invalid token or user_id missing'
          render json: { error: 'Invalid token' }, status: :unauthorized and return
        end

        @current_user = User.find_by_id(decoded_token['user_id'])

        Rails.logger.info "User class: #{@current_user.email}"

        if @current_user.nil?
          Rails.logger.error 'User not found for given token'
          render json: { error: 'Invalid token' }, status: :unauthorized and return
        end
      end
    end
  end
end
