module Orders
  class PurchaseCountStrategy
    STRATEGIES = {
      'day'  => ::Orders::PurchaseCountByDay,
      'hour' => ::Orders::PurchaseCountByHour,
      'week' => ::Orders::PurchaseCountByWeek,
      'year' => ::Orders::PurchaseCountByYear
    }

    def self.build(granularity)
      strategy = STRATEGIES[granularity]

      raise "Unsupported granularity: #{granularity.inspect}" unless strategy

      strategy.new
    end
  end
end