class AdminMailer < ActionMailer::Base
  default from: 'notifications@example.com'

  def first_purchase_notification(product)
    @product = product
    admin_emails = User.admins.pluck(:email)

    mail(to: admin_emails, subject: "Primer compra de #{@product.name}")
  end

  def daily_sales_report(admin_email, order_ids)
    @orders = Order.where(id: order_ids)
    
    mail(to: admin_email, subject: "Reporte Diario de Compras")
  end
end