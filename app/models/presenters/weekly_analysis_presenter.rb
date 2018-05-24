module Presenters
  class WeeklyAnalysisPresenter
    def initialize(cohort, weekly_segments)
      @cohort = cohort
      @segment_count = weekly_segments.count
    end

    def weekly_data
      (0...segment_count).map do |i|
        if i < cohort.weekly_analyses.count
          analysis = cohort.weekly_analyses[i]
          user_order_content = user_order_content(analysis, cohort.total_user_count)
          user_first_order_content = user_first_order_content(analysis, cohort.total_user_count)

          WeeklyAnalysisDatum.new(user_order_content, user_first_order_content)
        else
          nil
        end
      end
    end

    private

    def user_order_content(analysis, total_user_count)
      if total_user_count == 0
        return "0 orderers. 0%"
      end

      percentage = ((analysis.user_order_count/total_user_count.to_f) * 100).to_i
      "#{analysis.user_order_count} orderers. #{percentage}%"
    end

    def user_first_order_content(analysis, total_user_count)
      if total_user_count == 0
        return "0 1st orderers. 0%"
      end

      percentage = ((analysis.user_first_order_count/total_user_count.to_f) * 100).to_i
      "#{analysis.user_first_order_count} 1st orderers. #{percentage}%"
    end

    attr_reader :cohort, :segment_count

    WeeklyAnalysisDatum = Struct.new(:user_order_content, :user_first_order_content)
  end
end
