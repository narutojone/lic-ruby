require 'spec_helper'

describe TimeHelper do
  before do
    Time.zone = 'UTC'
  end

  #----------------------------------------------------------------------------
  describe '.time_range_by_param' do
    it 'returns range for last 7 days' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_7_days')
        expect(times.first).to eq(Time.utc(2016, 7, 12, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 19, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_7_days')
        expect(times.first).to eq(Time.utc(2016, 7, 11, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 18, 17))
      end
    end

    it 'returns range for last 14 days' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_14_days')
        expect(times.first).to eq(Time.utc(2016, 7, 5, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 19, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_14_days')
        expect(times.first).to eq(Time.utc(2016, 7, 4, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 18, 17))
      end
    end

    it 'returns range for last 30 days' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_30_days')
        expect(times.first).to eq(Time.utc(2016, 6, 19, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 19, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_30_days')
        expect(times.first).to eq(Time.utc(2016, 6, 18, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 18, 17))
      end
    end

    it 'returns range for this week' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_week')
        expect(times.first).to eq(Time.utc(2016, 7, 18, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 25, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_week')
        expect(times.first).to eq(Time.utc(2016, 7, 17, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 24, 17))
      end
    end

    it 'returns range for last week' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_week')
        expect(times.first).to eq(Time.utc(2016, 7, 11, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 18, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_week')
        expect(times.first).to eq(Time.utc(2016, 7, 10, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 17, 17))
      end
    end

    it 'returns range for this month' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_month')
        expect(times.first).to eq(Time.utc(2016, 7, 1, 0))
        expect(times.last).to eq(Time.utc(2016, 8, 1, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_month')
        expect(times.first).to eq(Time.utc(2016, 6, 30, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 31, 17))
      end
    end

    it 'returns range for last month' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_month')
        expect(times.first).to eq(Time.utc(2016, 6, 1, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 1, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_month')
        expect(times.first).to eq(Time.utc(2016, 5, 31, 17))
        expect(times.last).to eq(Time.utc(2016, 6, 30, 17))
      end
    end

    it 'returns range for this year' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_year')
        expect(times.first).to eq(Time.utc(2016, 1, 1, 0))
        expect(times.last).to eq(Time.utc(2017, 1, 1, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('this_year')
        expect(times.first).to eq(Time.utc(2015, 12, 31, 17))
        expect(times.last).to eq(Time.utc(2016, 12, 31, 17))
      end
    end

    it 'returns range for last year' do
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_year')
        expect(times.first).to eq(Time.utc(2015, 1, 1, 0))
        expect(times.last).to eq(Time.utc(2016, 1, 1, 0))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 19)) do
        times = TimeHelper.time_range_by_param('last_year')
        expect(times.first).to eq(Time.utc(2014, 12, 31, 17))
        expect(times.last).to eq(Time.utc(2015, 12, 31, 17))
      end
    end

    describe 'custom range' do
      it 'returns range for custom dates' do
        times = TimeHelper.time_range_by_param('custom', '2016-07-06', '2016-07-23')
        expect(times.first).to eq(Time.utc(2016, 7, 6, 0))
        expect(times.last).to eq(Time.utc(2016, 7, 24, 0))

        Time.zone = 'Bangkok' # UTC+7
        times = TimeHelper.time_range_by_param('custom', '2016-07-06', '2016-07-23')
        expect(times.first).to eq(Time.utc(2016, 7, 5, 17))
        expect(times.last).to eq(Time.utc(2016, 7, 23, 17))
      end

      it 'replaces erroneus date with nil' do
        times = TimeHelper.time_range_by_param('custom', 'invalid', '2016-07-23')
        expect(times.first).to eq(nil)
        expect(times.last).to eq(Time.utc(2016, 7, 24, 0))
      end

      it 'replaces blank date with nil'do
        times = TimeHelper.time_range_by_param('custom', '2016-07-06', '')
        expect(times.first).to eq(Time.utc(2016, 7, 6, 0))
        expect(times.last).to eq(nil)
      end
    end
  end

  describe '.date_range_by_param' do
    it 'returns range for last 7 days' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_7_days')
        expect(dates.first).to eq(Date.civil(2016, 7, 14))
        expect(dates.last).to eq(Date.civil(2016, 7, 20))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 21, 17)) do
        dates = TimeHelper.date_range_by_param('last_7_days')
        expect(dates.first).to eq(Date.civil(2016, 7, 15))
        expect(dates.last).to eq(Date.civil(2016, 7, 21))
      end
    end

    it 'returns range for last 14 days' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_14_days')
        expect(dates.first).to eq(Date.civil(2016, 7, 7))
        expect(dates.last).to eq(Date.civil(2016, 7, 20))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 21, 17)) do
        dates = TimeHelper.date_range_by_param('last_14_days')
        expect(dates.first).to eq(Date.civil(2016, 7, 8))
        expect(dates.last).to eq(Date.civil(2016, 7, 21))
      end
    end

    it 'returns range for last 30 days' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_30_days')
        expect(dates.first).to eq(Date.civil(2016, 6, 21))
        expect(dates.last).to eq(Date.civil(2016, 7, 20))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 21, 17)) do
        dates = TimeHelper.date_range_by_param('last_30_days')
        expect(dates.first).to eq(Date.civil(2016, 6, 22))
        expect(dates.last).to eq(Date.civil(2016, 7, 21))
      end
    end

    it 'returns range for this week' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('this_week')
        expect(dates.first).to eq(Date.civil(2016, 7, 18))
        expect(dates.last).to eq(Date.civil(2016, 7, 24))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 24, 17)) do
        dates = TimeHelper.date_range_by_param('this_week')
        expect(dates.first).to eq(Date.civil(2016, 7, 25))
        expect(dates.last).to eq(Date.civil(2016, 7, 31))
      end
    end

    it 'returns range for last week' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_week')
        expect(dates.first).to eq(Date.civil(2016, 7, 11))
        expect(dates.last).to eq(Date.civil(2016, 7, 17))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 17, 17)) do
        dates = TimeHelper.date_range_by_param('last_week')
        expect(dates.first).to eq(Date.civil(2016, 7, 11))
        expect(dates.last).to eq(Date.civil(2016, 7, 17))
      end
    end

    it 'returns range for this month' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('this_month')
        expect(dates.first).to eq(Date.civil(2016, 7, 1))
        expect(dates.last).to eq(Date.civil(2016, 7, 31))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 31, 17)) do
        dates = TimeHelper.date_range_by_param('this_month')
        expect(dates.first).to eq(Date.civil(2016, 8, 1))
        expect(dates.last).to eq(Date.civil(2016, 8, 31))
      end
    end

    it 'returns range for last month' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_month')
        expect(dates.first).to eq(Date.civil(2016, 6, 1))
        expect(dates.last).to eq(Date.civil(2016, 6, 30))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 7, 31, 17)) do
        dates = TimeHelper.date_range_by_param('last_month')
        expect(dates.first).to eq(Date.civil(2016, 7, 1))
        expect(dates.last).to eq(Date.civil(2016, 7, 31))
      end
    end

    it 'returns range for this year' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('this_year')
        expect(dates.first).to eq(Date.civil(2016, 1, 1))
        expect(dates.last).to eq(Date.civil(2016, 12, 31))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 12, 31, 17)) do
        dates = TimeHelper.date_range_by_param('this_year')
        expect(dates.first).to eq(Date.civil(2017, 1, 1))
        expect(dates.last).to eq(Date.civil(2017, 12, 31))
      end
    end

    it 'returns range for last year' do
      Timecop.freeze(Time.utc(2016, 7, 21)) do
        dates = TimeHelper.date_range_by_param('last_year')
        expect(dates.first).to eq(Date.civil(2015, 1, 1))
        expect(dates.last).to eq(Date.civil(2015, 12, 31))
      end

      Time.zone = 'Bangkok' # UTC+7
      Timecop.freeze(Time.utc(2016, 12, 31, 17)) do
        dates = TimeHelper.date_range_by_param('last_year')
        expect(dates.first).to eq(Date.civil(2016, 1, 1))
        expect(dates.last).to eq(Date.civil(2016, 12, 31))
      end
    end

    describe 'custom range' do
      it 'returns range for custom dates' do
        dates = TimeHelper.date_range_by_param('custom', '2016-07-06', '2016-07-23')
        expect(dates.first).to eq(Date.civil(2016, 7, 6))
        expect(dates.last).to eq(Date.civil(2016, 7, 23))

        Time.zone = 'Bangkok' # UTC+7
        dates = TimeHelper.date_range_by_param('custom', '2016-07-06', '2016-07-23')
        expect(dates.first).to eq(Date.civil(2016, 7, 6))
        expect(dates.last).to eq(Date.civil(2016, 7, 23))
      end

      it 'replaces erroneus date with nil' do
        dates = TimeHelper.date_range_by_param('custom', 'invalid', '2016-07-23')
        expect(dates.first).to eq(nil)
        expect(dates.last).to eq(Date.civil(2016, 7, 23))
      end

      it 'replaces blank date with nil'do
        dates = TimeHelper.date_range_by_param('custom', '2016-07-06', '')
        expect(dates.first).to eq(Date.civil(2016, 7, 6))
        expect(dates.last).to eq(nil)
      end
    end
  end
end
