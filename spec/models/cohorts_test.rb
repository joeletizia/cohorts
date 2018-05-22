require "rails_helper"

describe Cohorts do
  describe ".build_and_analyze" do
    let!(:user1) { User.create(created_at: 2.weeks.ago) }
    let!(:user2) { User.create(created_at: 2.days.ago) }
    let!(:order1) { Order.create(user: user1, created_at: 2.weeks.ago, order_number: 1) }
    let!(:order2) { Order.create(user: user1, created_at: 9.days.ago, order_number: 2) }
    let!(:order3) { Order.create(user: user2, created_at: 1.days.ago, order_number: 1) }

    it 'returns an analysis for each week of valid data' do
      analyses = Cohorts::build_and_analyze(1.days.ago.end_of_day, 2)
      expect(analyses.count).to eq(3)

      first_cohort_analysis = analyses.first
      expect(first_cohort_analysis.total_user_count).to eq(1)
      expect(first_cohort_analysis.weekly_analyses.count).to eq(3)

      first_weekly_analysis = first_cohort_analysis.weekly_analyses.first
      expect(first_weekly_analysis.user_order_count).to eq(1)
      expect(first_weekly_analysis.user_first_order_count).to eq(1)

      second_cohort_analysis = analyses[1]
      expect(second_cohort_analysis.total_user_count).to eq(1)
      expect(second_cohort_analysis.weekly_analyses.count).to eq(2)

      second_weekly_analysis = second_cohort_analysis.weekly_analyses.first
      expect(second_weekly_analysis.user_order_count).to eq(1)
      expect(second_weekly_analysis.user_first_order_count).to eq(1)

      third_cohort_analysis = analyses[2]
      expect(third_cohort_analysis.total_user_count).to eq(0)
      expect(third_cohort_analysis.weekly_analyses.count).to eq(1)

      third_weekly_analysis = third_cohort_analysis.weekly_analyses.first
      expect(third_weekly_analysis.user_order_count).to eq(0)
      expect(third_weekly_analysis.user_first_order_count).to eq(0)
    end
  end
end
