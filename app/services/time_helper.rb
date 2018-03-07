class TimeHelper

  # range start is inclusive, range end is exclusive
  # so the DB query should be something like "created_at >= :start AND created_at < :end"
  def self.time_range_by_param(range_param, custom_start = nil, custom_end = nil)
    now = Time.now.in_time_zone
    case range_param
    when 'last_7_days'
      this_morning = now.at_beginning_of_day
      [this_morning - 1.week, this_morning]
    when 'last_14_days'
      this_morning = now.at_beginning_of_day
      [this_morning - 2.weeks, this_morning]
    when 'last_30_days'
      this_morning = now.at_beginning_of_day
      [this_morning - 30.days, this_morning]
    when 'this_week'
      [now.at_beginning_of_week, (now + 1.week).at_beginning_of_week]
    when 'last_week'
      [(now - 1.week).at_beginning_of_week, now.at_beginning_of_week]
    when 'this_month'
      [now.at_beginning_of_month, (now + 1.month).at_beginning_of_month]
    when 'last_month'
      [(now - 1.month).at_beginning_of_month, now.at_beginning_of_month]
    when 'this_year'
      [now.at_beginning_of_year, (now + 1.year).at_beginning_of_year]
    when 'last_year'
      [(now - 1.year).at_beginning_of_year, now.at_beginning_of_year]
    when 'custom'
      start_date = parse_date(custom_start)
      end_date = parse_date(custom_end)
      [start_date.nil? ? nil : start_date.in_time_zone, end_date.nil? ? nil : (end_date.in_time_zone + 1.day).at_beginning_of_day]
    end
  end

  # range start and end are inclusive
  # so the DB query should be something like "created_at BETWEEN :start AND :end"
  # or "created_at >= :start AND created_at <= :end"
  def self.date_range_by_param(range_param, custom_start = nil, custom_end = nil)
    today = Time.zone.today
    case range_param
    when 'last_7_days'
      [today - 1.week, today - 1.day]
    when 'last_14_days'
      [today - 2.weeks, today - 1.day]
    when 'last_30_days'
      [today - 30.days, today - 1.day]
    when 'this_week'
      [today.beginning_of_week, today.end_of_week]
    when 'last_week'
      last_week = today - 1.week
      [last_week.beginning_of_week, last_week.end_of_week]
    when 'this_month'
      [today.beginning_of_month, today.end_of_month]
    when 'last_month'
      last_month = today - 1.month
      [last_month.beginning_of_month, last_month.end_of_month]
    when 'this_year'
      [today.beginning_of_year, today.end_of_year]
    when 'last_year'
      last_year = today - 1.year
      [last_year.beginning_of_year, last_year.end_of_year]
    when 'custom'
      start_date = parse_date(custom_start)
      end_date = parse_date(custom_end)
      [start_date.nil? ? nil : start_date, end_date.nil? ? nil : end_date]
    end
  end

  private

  def self.parse_date(date_str)
    begin
      Date.strptime(date_str, '%Y-%m-%d')
    rescue ArgumentError
      nil
    end
  end

end
