module Orders
  module_function

  def for_users_between_dates(users, start_date, end_date)
    Order.where(user: users, created_at: start_date..end_date)
  end

  def none_exist?
    Order.first.nil?
  end

  def for_users_that_were_processed_between(users, start_date, end_date)
    Order.where(user: users).where(created_at: start_date..end_date)
  end

  def first_orders_for_users_that_were_processed_between(users, start_date, end_date)
    Order.where(user: users).where(created_at: start_date..end_date).where(order_number: 1)
  end
end
