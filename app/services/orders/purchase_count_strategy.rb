module Orders
  class PurchaseCountStrategy
    STRATEGIES = {
      'day'  => PurchaseCountByDay,
      'hour' => PurchaseCountByHour,
      'week' => PurchaseCountByWeek,
      'year' => PurchaseCountByYear
    }

    def self.build(granularity)
      strategy = STRATEGIES[granularity]

      raise "Unsupported granularity: #{granularity.inspect}" unless strategy

      strategy.new
    end
  end
end