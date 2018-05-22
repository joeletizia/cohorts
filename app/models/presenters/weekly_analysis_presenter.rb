module Presenters
  class WeeklyAnalysisPresenter
    def initialize(segment, cohort)
      @total_user_count = cohort.total_user_count
      @weekly_analysis = cohort.weekly_analyses.find{|analysis| analysis.start_date == segment}
    end

    def has_data_for_this_segment?
      weekly_analysis.present?
    end

    def user_order_content
      if weekly_analysis.nil?
        return "NA"
      end

      if total_user_count == 0
        return "0 orderers. 0%"
      end

      percentage = ((weekly_analysis.user_order_count/total_user_count.to_f) * 100).to_i
      "#{weekly_analysis.user_order_count} orderers. #{percentage}%"
    end

    def user_first_order_content
      if weekly_analysis.nil?
        return "NA"
      end

      if total_user_count == 0
        return "0 1st orderers. 0%"
      end

      percentage = ((weekly_analysis.user_first_order_count/total_user_count.to_f) * 100).to_i
      "#{weekly_analysis.user_first_order_count} 1st orderers. #{percentage}%"
    end

    private

    attr_reader :weekly_analysis, :total_user_count
  end
end
