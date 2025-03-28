class AddIndexToProdoctAndCustomer < ActiveRecord::Migration
 def change
    add_index :orders, :product_id
    add_index :orders, :customer_id
  end
end
