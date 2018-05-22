require "rails_helper"

describe Presenters::WeeklyAnalysisPresenter do
  describe "#has_data_for_this_segment?" do
    context 'when the weekly analysis does not have data for the given segment' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment + 7.days)] }

      it 'returns false' do
        cohort = double(total_user_count: 3, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)

        expect(presenter.has_data_for_this_segment?).to eq(false)
      end
    end
    context 'when the weekly analysis does have data for the given segment' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment)] }

      it 'returns true' do
        cohort = double(total_user_count: 3, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)

        expect(presenter.has_data_for_this_segment?).to eq(true)
      end
    end
  end

  describe "#user_order_content" do
    context 'when the weekly analysis is nil' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment - 7.days)] }

      it 'returns "NA"' do
        cohort = double(total_user_count: 3, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_order_content).to eq("NA")
      end
    end

    context 'when the total user count is 0' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment)] }

      it 'returns "0 orderers. 0%"' do
        cohort = double(total_user_count: 0, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_order_content).to eq("0 orderers. 0%")
      end
    end

    context 'when there is a matching analysis to the given segment' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment, user_order_count: 1)] }

      it 'returns a string containing the number of unique orderers and the percentage against the total' do
        cohort = double(total_user_count: 1, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_order_content).to eq("1 orderers. 100%")
      end
    end
  end

  describe "#user_first_order_content" do
    context 'when the weekly analysis is nil' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment - 7.days)] }

      it 'returns "NA"' do
        cohort = double(total_user_count: 3, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_first_order_content).to eq("NA")
      end
    end

    context 'when the total user count is 0' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment)] }

      it 'returns "0 orderers. 0%"' do
        cohort = double(total_user_count: 0, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_first_order_content).to eq("0 1st orderers. 0%")
      end
    end

    context 'when there is a matching analysis to the given segment' do
      let(:segment) { Date.today }
      let(:analyses) { [double(start_date: segment, user_first_order_count: 1)] }

      it 'returns a string containing the number of unique orderers and the percentage against the total' do
        cohort = double(total_user_count: 1, weekly_analyses: analyses)
        presenter = Presenters::WeeklyAnalysisPresenter.new(segment, cohort)
        expect(presenter.user_first_order_content).to eq("1 1st orderers. 100%")
      end
    end
  end
end
