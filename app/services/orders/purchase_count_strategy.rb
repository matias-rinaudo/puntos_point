module Orders
  class PurchaseCountStrategy
    STRATEGIES = {
      'day'  => ::Order::PurchaseCountByDay,
      'hour' => ::Order::PurchaseCountByHour,
      'week' => ::Order::PurchaseCountByWeek,
      'year' => ::Order::PurchaseCountByYear
    }

    def self.build(granularity)
      strategy = STRATEGIES[granularity]

      raise "Unsupported granularity: #{granularity.inspect}" unless strategy

      strategy.new
    end
  end
end