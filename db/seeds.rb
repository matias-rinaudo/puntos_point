##ROLES

admin = Role.find_or_create_by_name!(name: 'Admin')
customer = Role.find_or_create_by_name!(name: 'Customer')

##USUARIOS

admin_matias = User.find_or_create_by_email!(
  email: 'matias@admin.com',
  password: 'password123*',
  password_confirmation: 'password123*',
  role_id: admin.id
)

admin_sebastian = User.find_or_create_by_email!(
  email: 'sebastian@admin.com',
  password: 'password123*',
  password_confirmation: 'password123*',
  role_id: admin.id
)

customer = User.find_or_create_by_email!(
  email: 'customer@example.com',
  password: 'password123*',
  password_confirmation: 'password123*',
  role_id: customer.id
)

## CATEGORIAS

electronics = Category.find_or_create_by_name!(name: 'Electronics')
gamer = Category.find_or_create_by_name!(name: 'Gamer')
home = Category.find_or_create_by_name!(name: 'Home & Kitchen')

##PRODUCTOS

Product.find_or_create_by_name!(
  name: 'Notebook',
  price: 1200.99,
  creator_id: admin_matias.id,
  categories: [electronics]
)

Product.find_or_create_by_name!(
  name: 'Iphone 16',
  price: 799.99,
  creator_id: admin_sebastian.id,
  categories: [electronics, gamer]
)

Product.find_or_create_by_name!(
  name: 'Sillon',
  price: 499.99,
  creator_id: admin_sebastian.id,
  categories: [home]
)

Product.find_or_create_by_name!(
  name: 'Silla',
  price: 200.99,
  creator_id: admin_matias.id,
  categories: [home]
)

Product.find_or_create_by_name!(
  name: 'Mesa',
  price: 300.99,
  creator_id: admin_matias.id,
  categories: [home]
)

##ORDERS

10.times do
  product = Product.all.sample
  quantity = rand(1..10)

  Order.create!(
    product_id: product.id,
    customer_id: customer.id,
    quantity: quantity,
    created_at: Time.zone.at(rand(30.days.ago.to_i..Time.zone.now.to_i))
  )
end
