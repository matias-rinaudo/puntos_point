module Api
  module V1
    class AuthController < Api::V1::BaseApiController
      def login
        user = User.find_by_email(params[:email])

        if user && user.valid_password?(params[:password])
          if user.admin?
            token = JsonWebToken.encode(user_id: user.id)
            render json: { token: token, user_id: user.id }, status: :ok
          else
            render json: { error: 'Unauthorized: Not an admin' }, status: :unauthorized
          end
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end
