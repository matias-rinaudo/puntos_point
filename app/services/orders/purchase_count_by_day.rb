class PurchaseCountByDay
  def execute(orders)
    orders = orders
      .select("DATE_TRUNC('day', orders.created_at) AS day, COUNT(*) AS count")
      .group("DATE_TRUNC('day', orders.created_at)")
      .order("day ASC")

    result = {}
    orders.each do |order|
      day = order.day.to_date.strftime("%Y-%m-%d")
      result[day] = order.count
    end
    
    result
  end
end