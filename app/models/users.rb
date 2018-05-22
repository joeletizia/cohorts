module Users
  module_function

  def created_between(start_date, end_date)
    User.where(created_at: start_date..end_date)
  end
end
