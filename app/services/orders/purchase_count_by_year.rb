class PurchaseCountByYear
  def execute(orders)
    orders = orders
      .select("EXTRACT(YEAR FROM orders.created_at) AS year, COUNT(*) AS count")
      .group("EXTRACT(YEAR FROM orders.created_at)")
      .order("year ASC")

    result = {}
    orders.each do |order|
      result[order.year.to_s] = order.count
    end
    
    result
  end
end