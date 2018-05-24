require "rails_helper"

describe Presenters::WeeklyAnalysisPresenter do
  describe "#weekly_data" do
    context 'when there are more segments to display than the cohort has weeks' do
      it 'returns a collection contianing nil' do
        segments = [1,2]
        cohort = double(total_user_count: 1, weekly_analyses: [double(user_order_count: 1, user_first_order_count: 1)])
        presenter = Presenters::WeeklyAnalysisPresenter.new(cohort, segments)

        weekly_data = presenter.weekly_data
        expect(weekly_data.count).to eq(segments.count)
        expect(weekly_data.last).to eq(nil)
      end
    end

    context 'when there is weekly data to be displayed' do
      it 'returns a collection contianing an object with string data to display' do
        segments = [1,2]
        cohort = double(total_user_count: 1, weekly_analyses: [double(user_order_count: 1, user_first_order_count: 1)])
        presenter = Presenters::WeeklyAnalysisPresenter.new(cohort, segments)

        weekly_data = presenter.weekly_data
        expect(weekly_data.count).to eq(segments.count)
        expect(weekly_data.first.user_order_content).to eq("1 orderers. 100%")
        expect(weekly_data.first.user_first_order_content).to eq("1 1st orderers. 100%")
      end
    end

    context 'when the total user count is 0' do
      it 'returns a collection contianing an object with string data showing 0%' do
        segments = [1,2]
        cohort = double(total_user_count: 0, weekly_analyses: [double(user_order_count: 0, user_first_order_count: 0)])
        presenter = Presenters::WeeklyAnalysisPresenter.new(cohort, segments)

        weekly_data = presenter.weekly_data
        expect(weekly_data.count).to eq(segments.count)
        expect(weekly_data.first.user_order_content).to eq("0 orderers. 0%")
        expect(weekly_data.first.user_first_order_content).to eq("0 1st orderers. 0%")
      end
    end
  end
end
