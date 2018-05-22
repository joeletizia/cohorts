require 'set'

module AnalysesHelper
  def get_weekly_segments_for_headers(cohorts)
    cohorts.reduce(Set.new) do |acc, analysis|
      weekly_starts = analysis.weekly_analyses.map do |weekly_analysis|
        weekly_analysis.start_date
      end

      acc.merge(weekly_starts)
    end
  end
end
