module Api
  module V1
    class BaseApiController < ActionController::API
      before_action :authenticate_request

      def authenticate_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header

        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id]) if decoded

        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user.admin?
      end
    end
  end
end
