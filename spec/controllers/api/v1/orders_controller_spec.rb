require 'rails_helper'

RSpec.describe ::Api::V1::OrdersController, type: :controller do
  let!(:admin_user) { create(:user, :admin) }
  let!(:order) { create(:order) }
  let!(:customer_user) { create(:user, :customer) }

  before do
    request.env["HTTP_AUTHORIZATION"] = "Bearer #{admin_user.auth_token}"
  end

  describe "GET #index" do
    it "returns a filtered list of orders" do
      get :index, params: { from: '2025-03-01', to: '2025-03-31', category_id: order.category.id }

      expect(response).to have_http_status(:success)
      expect(json_response).to be_an(Array)
      expect(json_response.first['id']).to eq(order.id)
    end
  end

  describe "GET #by_granularity" do
    it "returns orders grouped by day granularity" do
      get :by_granularity, params: { from: '2025-03-01', to: '2025-03-31', granularity: 'day' }

      expect(response).to have_http_status(:success)
      expect(json_response).to be_an(Array)
      expect(json_response.first).to have_key('date')
    end

    it "returns orders grouped by week granularity" do
      get :by_granularity, params: { from: '2025-03-01', to: '2025-03-31', granularity: 'week' }

      expect(response).to have_http_status(:success)
      expect(json_response).to be_an(Array)
      expect(json_response.first).to have_key('date')
    end
  end
end
