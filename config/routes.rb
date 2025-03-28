Code::Application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get 'products/most_purchased_by_category', to: 'products#most_purchased_by_category'
      get 'products/top_revenue', to: 'products#top_revenue_products'
      get 'orders', to: 'orders#index'
      get 'orders/granularity', to: 'orders#by_granularity'
    end
  end
end
