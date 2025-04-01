class DailyReportJob
  include Sidekiq::Worker

  def perform
    start_date = Time.zone.now - 1.day
    end_date = Time.zone.now - 1.day

    orders = Order.created_at_range(start_date, end_date)
    
    User.admins.each do |admin|
      AdminMailer.daily_sales_report(admin.email, orders.pluck(:id)).deliver
    end
  end
end