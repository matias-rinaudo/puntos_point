class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :customer_id, index: true
      t.integer :product_id, index: true
      t.integer :quantity
      t.timestamps
    end
  end
end
