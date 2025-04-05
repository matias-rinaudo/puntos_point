class Product < ActiveRecord::Base
  attr_accessible :name, :price, :creator_id, :categories, :images, :orders

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_and_belongs_to_many :categories
  has_many :images, as: :imageable
  has_many :orders

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def self.top_purchased_by_category
    products = Rails.cache.fetch("top_purchased_by_category", expires_in: 12.hours) do
      Product.joins(:categories, :orders)
              .select('categories.id AS category_id, products.id AS product_id, products.name, COUNT(orders.id) AS order_count')
              .group('categories.id, products.id, products.name')
              .having('COUNT(orders.id) = (
                SELECT MAX(order_counts.total)
                FROM (
                  SELECT COUNT(orders.id) AS total
                  FROM products
                  JOIN categories_products ON categories_products.product_id = products.id
                  JOIN orders ON orders.product_id = products.id
                  WHERE categories_products.category_id = categories.id
                  GROUP BY products.id
                ) AS order_counts
              )')
    end
  end

  def self.top_revenue_by_category
    products = Rails.cache.fetch("top_revenue_by_category", expires_in: 12.hours) do
      Product.joins(:categories, :orders)
              .select('categories.id AS category_id, products.id AS product_id, products.name, SUM(orders.total) AS total_revenue')
              .group('categories.id, products.id, products.name')
              .having('(
                SELECT COUNT(*) FROM (
                  SELECT products.id, SUM(orders.total) AS revenue
                  FROM products
                  JOIN categories_products ON categories_products.product_id = products.id
                  JOIN orders ON orders.product_id = products.id
                  WHERE categories_products.category_id = categories.id
                  GROUP BY products.id
                  HAVING SUM(orders.total) > SUM(orders.total)
                ) AS ranked
              ) < 3')
    end
  end
end
