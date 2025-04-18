module Api
  module V1
    class ProductsController < Api::V1::BaseApiController
      before_filter :authorize_admin, only: [:most_purchased_by_category, :top_revenue_products]
      before_filter :authenticate_request, only: [:most_purchased_by_category, :top_revenue_products]
        
      def most_purchased_by_category
        products = Product.top_purchased_by_category.paginate(page: params[:page], per_page: 10)

        render json: products.as_json(only: [:id, :name, :orders_count])
      end

      def top_revenue_products
        products = Product.top_revenue_by_category.paginate(page: params[:page], per_page: 10)

        render json: products.as_json(only: [:id, :name])
      end
    end
  end
end
