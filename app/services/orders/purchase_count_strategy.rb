class InvalidGranularityError < StandardError; end

class PurchaseCountStrategy
  def self.build(granularity)
    case granularity
    when 'day'
      PurchaseCountByDay.new
    when 'hour'
      PurchaseCountByHour.new
    when 'week'
      PurchaseCountByWeek.new
    when 'year'
      PurchaseCountByYear.new
    else
      raise InvalidGranularityError, "Unsupported granularity: #{granularity.inspect}"
    end
  end
end