module Api
  module V1
    class OrdersController < Api::V1::BaseApiController
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
                                                    granularity: params[:granularity] || 'day').paginate(page: params[:page], per_page: 10)

        render json: orders.as_json
      end
    end
  end
end
