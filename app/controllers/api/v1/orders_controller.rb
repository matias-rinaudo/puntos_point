module Api
  module V1
    class OrdersController < Api::V1::BaseApiController
      before_filter :authorize_admin, only: [:index, :by_granularity]
      before_filter :authenticate_request, only: [:index, :by_granularity]

      def index
        orders = Order.filtered(start_date: params[:from],
                                end_date: params[:to],
                                category_id: params[:category_id],
                                customer_id: params[:customer_id],
                                creator_id: params[:creator_id]).paginate(page: params[:page], per_page: 10)

        render json: orders.as_json
      end

      def by_granularity
        orders = Order.purchase_count_by_granularity(start_date: params[:from],
                                                    end_date: params[:to],
                                                    category_id: params[:category_id],
                                                    customer_id: params[:customer_id],
                                                    creator_id: params[:creator_id],
                                                    granularity: params[:granularity])

        render json: orders.as_json
      end
    end
  end
end
