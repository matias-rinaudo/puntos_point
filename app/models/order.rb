class Order < ActiveRecord::Base
  attr_accessible :product_id, :customer_id, :quantity, :total, :created_at

  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :product

  validates :product_id, :customer_id, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  scope :created_at_range, ->(start_date, end_date) { where(created_at: start_date.beginning_of_day..end_date.end_of_day) }
  scope :by_category_id, ->(category_id) { joins(product: :categories).where(categories: { id: category_id }) }
  scope :by_customer_id, ->(customer_id) { where(customer_id: customer_id) }
  scope :by_creator, ->(creator_id) { joins(:product).where(products: { creator_id: creator_id }) }
  scope :by_product_id, ->(product_id) { where(product_id: product_id) }

  before_save :set_total
  after_create :send_notification_to_admins

  def self.filtered(filters = {})
    start_date = filters[:start_date]
    end_date = filters[:end_date]
    category_id = filters[:category_id]
    customer_id = filters[:customer_id]
    creator_id = filters[:creator_id]

    cache_key = "orders_filtered_#{start_date}_#{end_date}_#{category_id}_#{customer_id}_#{creator_id}"

    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      orders = self.all
      orders = orders.created_at_range(start_date, end_date) if start_date.present? && end_date.present?
      orders = orders.by_category_id(category_id) if category_id.present?
      orders = orders.by_customer_id(customer_id) if customer_id.present?
      orders = orders.by_creator(creator_id) if creator_id.present?

      orders
    end
  end

  def self.purchase_count_by_granularity(filters = {})
    orders = self.filtered(filters)
    granularity = filters[:granularity]

    begin
      strategy = PurchaseCountStrategy.build(granularity)
      strategy.execute(orders)
    rescue InvalidGranularityError => e
      Rails.logger.warn "#{e.message}"
    rescue => e
      Rails.logger.warn "Unexpected error: #{e.message}"
    end
  end

  private

  def set_total
    self.total = product.price * quantity
  end

  def send_notification_to_admins
    AdminMailer.first_purchase_notification(self.product).deliver if Order.by_product_id(self.product.id).count == 1
  end
end