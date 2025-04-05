module Orders
  class PurchaseCountByWeek
    def execute(orders)
      orders = orders
        .select("DATE_TRUNC('week', orders.created_at) AS week, COUNT(*) AS count")
        .group("DATE_TRUNC('week', orders.created_at)")
        .order("week ASC")

      result = {}
      orders.each do |order|
        week_start = order.week.to_s.strip.to_time.strftime("%Y-%m-%d")
        result[week_start] = order.count
      end
      
      result
    end
  end
end