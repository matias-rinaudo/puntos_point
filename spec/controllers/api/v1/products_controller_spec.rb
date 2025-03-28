require 'rails_helper'

RSpec.describe ::Api::V1::ProductsController, type: :controller do
  let!(:admin_user) { create(:user, :admin) }
  let!(:product) { create(:product) }

  before do
    request.env["HTTP_AUTHORIZATION"] = "Bearer #{admin_user.auth_token}"
  end

  describe "GET #most_purchased_by_category" do
    context "when there are products" do
      before do
        allow(Product).to receive(:top_purchased_by_category).and_return([product])
        get :most_purchased_by_category  # Send a GET request
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the correct product data" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([{ "id" => product.id, "name" => product.name, "orders_count" => product.orders_count }])
      end
    end

    context "when no products are available" do
      before do
        allow(Product).to receive(:top_purchased_by_category).and_return([])
        get :most_purchased_by_category
      end

      it "returns an empty array" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end
  end

  describe "GET #top_revenue_products" do
    context "when there are products" do
      before do
        allow(Product).to receive(:top_revenue_by_category).and_return([product])
        get :top_revenue_products  # Send a GET request
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the correct product data" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([{ "id" => product.id, "name" => product.name }])
      end
    end

    context "when no products are available" do
      before do
        allow(Product).to receive(:top_revenue_by_category).and_return([])
        get :top_revenue_products  # Send a GET request
      end

      it "returns an empty array" do
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end
  end
end
