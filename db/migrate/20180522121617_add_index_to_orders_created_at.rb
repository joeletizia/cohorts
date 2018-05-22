class AddIndexToOrdersCreatedAt < ActiveRecord::Migration[5.1]
  def change
    add_index :orders, :created_at
    add_index :orders, :order_number
    add_index :users, :created_at
  end
end
