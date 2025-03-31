class DailyReportJob
  include Sidekiq::Worker

  def perform
    start_time = Time.zone.now.beginning_of_day - 1.day
    end_time = Time.zone.now.end_of_day - 1.day

    orders = Order.where(created_at: start_time..end_time)
    
    User.admins.each do |admin|
      AdminMailer.daily_sales_report(admin.email, orders.pluck(:id)).deliver_now
    end
  end
end