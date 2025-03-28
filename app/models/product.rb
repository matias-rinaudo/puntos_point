class Product < ActiveRecord::Base
  attr_accessible :name, :price, :creator_id, :categories, :images, :orders

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_and_belongs_to_many :categories
  has_many :images, as: :imageable
  has_many :orders

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  after_commit :clear_cache, on: [:create, :update, :destroy]

  def self.top_purchased_by_category
    products = Rails.cache.fetch("top_purchased_by_category", expires_in: 12.hours) do
      Product.joins(:orders, :categories)
             .select('products.*, categories.id AS category_id, COUNT(orders.id) AS orders_count')
             .group('products.id, categories.id')
             .order('categories.id, COUNT(orders.id) DESC')
    end
  end

  def self.top_revenue_by_category
    products = Rails.cache.fetch("top_revenue_by_category", expires_in: 12.hours) do
      Product.joins(:orders, :categories)
             .select('products.*, categories.id AS category_id, SUM(orders.total) AS total_revenue')
             .group('products.id, categories.id')
             .order('categories.id, total_revenue DESC')
             .limit(3)
    end
  end

  private

  def clear_cache
    Rails.cache.delete_matched("top_revenue_by_category*")
    Rails.cache.delete_matched("top_purchased_by_category*")
  end
end
