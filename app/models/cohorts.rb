require 'pmap'
require 'concurrent'

module Cohorts
  WeeklyAnalysis = Struct.new(:start_date, :user_order_count, :user_first_order_count)
  Analysis = Struct.new(:start_date, :total_user_count, :weekly_analyses)

  module_function

  def build_and_analyze(end_date, weeks_before_end_to_calculate = 8)
    return [] if Orders.none_exist?

    cohort_to_users_map = create_map_of_cohorts_to_users(end_date, weeks_before_end_to_calculate)
    build_analysis_data(cohort_to_users_map, end_date)
  end

  def create_map_of_cohorts_to_users(end_date, weeks_before_end_to_calculate)
    start_date = end_date.end_of_day - weeks_before_end_to_calculate.weeks
    buckets = create_buckets_from_start_and_end_dates(start_date, end_date)
    users_by_bucket = users_created_by_buckets(buckets)

    Hash[buckets.zip(users_by_bucket)]
  end

  def users_created_by_buckets(buckets)
    buckets.map do |bucket|
      Users::created_between(bucket, bucket + 7.days)
    end
  end

  def create_buckets_from_start_and_end_dates(start_date, end_date, buckets = [])
    if start_date > end_date
      return buckets.reverse
    end

    create_buckets_from_start_and_end_dates(start_date + 7.days, end_date, buckets << start_date)
  end

  def map_cohorts_to_users(cohorts)
    cohorts.reduce({}) do |acc, cohort|
      end_date = (cohort + 7.days)
      users = Users::created_between(cohort, end_date)
      acc[cohort] = users
      acc
    end
  end

  def build_analysis_data(cohort_to_users_map, end_date)
    return cohort_to_users_map.each_slice(Concurrent.physical_processor_count).map do |sliced_array_of_cohort_to_users|
      sliced_array_of_cohort_to_users.pmap do |cohort_start, users|
        total_user_count = users.count
        number_of_weeks_til_end = (end_date.to_i - cohort_start.to_i)/1.week + 1
        weekly_analyses = build_weekly_analyses(users, cohort_start, number_of_weeks_til_end)

        Analysis.new(cohort_start, total_user_count, weekly_analyses)
      end
    end.flatten
  end

  def build_weekly_analyses(users, start_date, number_of_weeks_to_end, built_analyses = [])
    return built_analyses if number_of_weeks_to_end <= 0

    this_weeks_analysis = build_order_analysis(users, start_date)
    build_weekly_analyses(users, start_date + 7.days, number_of_weeks_to_end - 1, built_analyses << this_weeks_analysis)
  end

  def build_order_analysis(users, start_date)
    users_that_ordered = users_that_made_at_least_one_order_in_week_of(users, start_date)
    users_that_made_first_order = users_that_made_first_order_in_week_of(users, start_date)

    WeeklyAnalysis.new(start_date, users_that_ordered.count, users_that_made_first_order.count)
  end

  def users_that_made_at_least_one_order_in_week_of(users, start_date)
    orders = Orders::for_users_that_were_processed_between(users, start_date, start_date + 7.days)

    orders.reduce(Set.new) do |set, order|
      set.add(order.user_id)
      set
    end.to_a
  end

  def users_that_made_first_order_in_week_of(users, start_date)
    orders = Orders::first_orders_for_users_that_were_processed_between(users, start_date, start_date + 7.days)

    orders.reduce(Set.new) do |set, order|
      set.add(order.user_id)
      set
    end.to_a
  end
end
