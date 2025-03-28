class Order < ActiveRecord::Base
  attr_accessible :product_id, :customer_id, :quantity, :total, :created_at

  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :product

  validates :product_id, :customer_id, :quantity, :total, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  before_save :set_total
  after_create :send_notification_to_admins

  def self.filtered(filters = {})
    start_date = filters[:start_date]
    end_date = filters[:end_date]
    category_id = filters[:category_id]
    customer_id = filters[:customer_id]
    creator_id = filters[:creator_id]

    orders = Order.joins(:product, :customer, product: :categories)

    orders = orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day) if start_date.present? && end_date.present?
    orders = orders.where(categories: { id: category_id }) if category_id.present?
    orders = orders.by_customer_id(customer_id) if customer_id.present?
    orders = orders.where(products: { creator_id: creator_id }) if creator_id.present?
    
    orders
  end

  def self.purchase_count_by_granularity(filters = {})
    start_date = filters[:start_date]
    end_date = filters[:end_date]
    category_id = filters[:category_id]
    customer_id = filters[:customer_id]
    creator_id = filters[:creator_id]
    granularity = filters[:granularity]

    orders = Order.filtered(start_date: start_date, end_date: end_date, category_id: category_id, customer_id: customer_id, creator_id: creator_id)

    case granularity
    when 'hour'
      orders = orders.select("DATE_TRUNC('hour', orders.created_at) AS time_group, COUNT(*) AS count")
                     .group("DATE_TRUNC('hour', orders.created_at)")
    when 'day'
      orders = orders.select("DATE(orders.created_at) AS time_group, COUNT(*) AS count")
                     .group("DATE(orders.created_at)")
    when 'week'
      orders = orders.select("DATE_TRUNC('week', orders.created_at) AS time_group, COUNT(*) AS count")
                     .group("DATE_TRUNC('week', orders.created_at)")
    when 'year'
      orders = orders.select("EXTRACT(YEAR FROM orders.created_at) AS time_group, COUNT(*) AS count")
                     .group("EXTRACT(YEAR FROM orders.created_at)")
    else
      raise "Invalid granularity specified"
    end

    orders.map do |order|
      time_group = if granularity == 'year'
                    order.time_group.to_s
                  else
                    order.time_group.is_a?(String) ? DateTime.parse(order.time_group) : order.time_group
                  end
      [time_group, order.count]
    end
  end

  def set_total
    self.total = product.price * quantity
  end

  private

  def send_notification_to_admins
    AdminMailer.first_purchase_notification(self.product).deliver if Order.where(product_id: self.product.id).count == 1
  end
end