module Orders
  class PurchaseCountByHour
    def execute(orders)
      orders = orders
        .select("DATE_TRUNC('hour', orders.created_at) AS hour, COUNT(*) AS count")
        .group("DATE_TRUNC('hour', orders.created_at)")
        .order("hour ASC")

      result = {}
      orders.each do |order|
        hour = order.hour.to_time.strftime("%Y-%m-%d %H:%M")
        result[hour] = order.count
      end
      
      result
    end
  end
end