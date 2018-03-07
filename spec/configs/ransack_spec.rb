require 'spec_helper'

describe 'Custom ransackers' do

  describe 'today' do
    it 'returns a between today query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_today: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-13 00:00:00' AND '2016-01-13 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_today: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-12 17:00:00' AND '2016-01-13 16:59:59.999999'")
      end
    end
  end

  describe 'tomorrow' do
    it 'returns a tomorrow query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_tomorrow: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-14 00:00:00' AND '2016-01-14 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_tomorrow: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-13 17:00:00' AND '2016-01-14 16:59:59.999999'")
      end
    end
  end

  describe 'yesterday' do
    it 'returns a between yesterday query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_yesterday: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-12 00:00:00' AND '2016-01-12 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_yesterday: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-11 17:00:00' AND '2016-01-12 16:59:59.999999'")
      end
    end
  end

  describe 'this_week' do
    it 'returns a between this week query (starting from Monday)' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_this_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-11 00:00:00' AND '2016-01-17 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_this_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-10 17:00:00' AND '2016-01-17 16:59:59.999999'")
      end
    end
  end

  describe 'last_week' do
    it 'returns a between last week query (starting from Monday)' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_last_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-04 00:00:00' AND '2016-01-10 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_last_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-03 17:00:00' AND '2016-01-10 16:59:59.999999'")
      end
    end
  end

  describe 'next_week' do
    it 'returns a between next week query (starting from Monday)' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_next_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-18 00:00:00' AND '2016-01-24 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_next_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-17 17:00:00' AND '2016-01-24 16:59:59.999999'")
      end
    end
  end

  describe 'this_month' do
    it 'returns a between this month query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_this_month: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2016-01-01 00:00:00' AND '2016-01-31 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_this_month: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2015-12-31 17:00:00' AND '2016-01-31 16:59:59.999999'")
      end
    end
  end

  describe 'last_month' do
    it 'returns a between last month query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_last_month: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2015-12-01 00:00:00' AND '2015-12-31 23:59:59.999999'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_last_month: '1').result.to_sql).to include("\"tickets\".\"created_at\" BETWEEN '2015-11-30 17:00:00' AND '2015-12-31 16:59:59.999999'")
      end
    end
  end

  describe 'in_the_past' do
    it 'returns a before now query' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
         expect(Ticket.ransack(created_at_in_the_past: '1').result.to_sql).to include("\"tickets\".\"created_at\" < '2016-01-13 12:00:00'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        # it is the same in Bangkok since we are always comparing with current time in UTC
        expect(Ticket.ransack(created_at_in_the_past: '1').result.to_sql).to include("\"tickets\".\"created_at\" < '2016-01-13 12:00:00'")
      end
    end
  end

  describe 'after_next_week' do
    it 'returns a after next week query (starting from Monday)' do
      Time.zone = 'UTC'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        expect(Ticket.ransack(created_at_after_next_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" >= '2016-01-25 00:00:00'")
      end
    end

    it 'adjusts to the current time zone' do
      Time.zone = 'Bangkok'
      Timecop.freeze(Time.utc(2016, 1, 13, 12)) do
        # it is the same in Bangkok since we are always comparing with current time in UTC
        expect(Ticket.ransack(created_at_after_next_week: '1').result.to_sql).to include("\"tickets\".\"created_at\" >= '2016-01-24 17:00:00'")
      end
    end
  end

  describe 'not_zero' do
    it 'returns a not zero string query' do
      expect(Ticket.ransack(revision_not_zero: '1').result.to_sql).to include("tickets.version_number != '0'")
    end
  end

  describe 'array_contains' do
    it 'uses custom arel array predicate' do
      expect(Ticket.ransack(additional_service_areas_array_contains: '1').result.to_sql).to include("\"additional_service_areas\" @> '{1}')")
    end
  end
end
