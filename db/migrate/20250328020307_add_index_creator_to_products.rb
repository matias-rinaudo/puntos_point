class AddIndexCreatorToProducts < ActiveRecord::Migration
  def change
    add_index :products, :creator_id
  end
end
