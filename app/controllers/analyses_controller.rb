class AnalysesController < ApplicationController
  DEFAULT_NUMBER_OF_WEEKS = 8

  def index
    last_order_date = Order.order(created_at: :desc).first.created_at
    number_of_weeks_to_display = params["number_of_weeks_to_display"] || DEFAULT_NUMBER_OF_WEEKS
    cohorts = Cohorts::build_and_analyze(last_order_date, number_of_weeks_to_display.to_i)

    render("index", locals: {cohorts: cohorts})
  end
end
