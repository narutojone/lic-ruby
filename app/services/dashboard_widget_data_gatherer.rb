class DashboardWidgetDataGatherer
  attr_reader :call_center

  def initialize(account, user, widget)
    @account  = account
    @user     = user
    @widget   = widget
    @partial  = widget.partial
    @settings = widget.settings || {}
    @call_center = @user.call_centers.select(:id, :name).find_by(id: widget.call_center_id)
  end

  def data
    return nil if @widget.has_settings? && @call_center.nil?

    results =
      case @partial
      when :number_of_users
        {
          number_of_users: @account.users.count,
          account_limit: @account.subscription.user_limit
        }
      when :user_roles_pie_chart
        {
          roles: @account.users.select('roles.id AS role_id, roles.name AS role_name, COUNT(roles.id) AS count').
            joins(:roles).group('roles.id, roles.name').order('count DESC')
        }
      when :number_of_tickets_assigned_to_me
        {
          number_of_tickets: @account.tickets.assigned.where(assignee: @user).count
        }
      when :number_of_assigned_tickets
        {
          number_of_tickets: @account.tickets.assigned.where(call_center: @call_center).count
        }
      when :number_of_incoming_tickets
        {
          number_of_tickets: @account.tickets.incoming.where(call_center: @call_center).count
        }
      when :open_ticket_types_pie_chart, :open_ticket_types
        {
          ticket_types: @account.tickets.open
                                        .where(call_center: @call_center)
                                        .select('call_center_id, ticket_type, count(ticket_type)')
                                        .group('call_center_id, ticket_type')
                                        .order('count DESC, ticket_type ASC')
                                        .includes(:call_center)
        }
      when :my_ticket_types_pie_chart
        {
          ticket_types: @account.tickets.assigned
                                        .where(assignee: @user)
                                        .select('call_center_id, ticket_type, count(ticket_type)')
                                        .group('call_center_id, ticket_type')
                                        .order('count DESC, ticket_type ASC')
                                        .includes(:call_center)
        }
      when :number_of_tickets_due_today
        {
          number_of_tickets: @account.tickets.open
                                             .where(call_center: @call_center)
                                             .where('response_due_at >= ? AND response_due_at < ?', Time.now.in_time_zone.beginning_of_day, Time.now.in_time_zone.tomorrow.beginning_of_day)
                                             .count
        }
      when :number_of_tickets_created_today
        {
          number_of_tickets: @account.tickets
                                     .where(call_center: @call_center)
                                     .where('created_at >= ? AND created_at < ?', Time.now.in_time_zone.beginning_of_day, Time.now.in_time_zone.tomorrow.beginning_of_day)
                                     .count
        }
      when :number_of_tickets_closed_today
        {
          number_of_tickets: @account.tickets
                                     .where(call_center: @call_center)
                                     .where('closed_at >= ? AND closed_at < ?', Time.now.in_time_zone.beginning_of_day, Time.now.in_time_zone.tomorrow.beginning_of_day)
                                     .count
        }
      when :number_of_open_tickets_past_due
        {
          number_of_tickets: @account.tickets.open.where(call_center: @call_center).where('response_due_at < ?', Time.now.in_time_zone).count
        }
      when :open_tickets_by_assignees_pie_chart
        {
          tickets_by_assignees: @account.tickets.assigned
                                                .where(call_center: @call_center)
                                                .select('users.id, users.first_name, users.last_name, count(tickets.id)')
                                                .joins('JOIN users ON (tickets.assignee_id = users.id)')
                                                .group('users.id, users.last_name, users.first_name')
                                                .order('count DESC, users.last_name, users.first_name')
        }
      when :my_tickets_due_times
        ticket_due_times(@account.tickets.assigned.where(assignee: @user))
      when :ticket_due_times
        ticket_due_times(@account.tickets.open.where(call_center: @call_center))
      when :total_tickets_vs_closed_tickets
        total_tickets = total_tickets_vs_closed_tickets_query('created_at')
        closed_tickets = total_tickets_vs_closed_tickets_query('closed_at')
        total_tickets_count = total_tickets.inject(0) { |sum, tt| sum + tt.count }
        closed_tickets_count = closed_tickets.inject(0) { |sum, ct| sum + ct.count }
        {
          total_tickets: total_tickets,
          closed_tickets: closed_tickets,
          total_tickets_count: total_tickets_count,
          closed_tickets_count: closed_tickets_count,
          closed_to_total_percentage: total_tickets_count > 0 ? ((closed_tickets_count.to_f / total_tickets_count) * 100).round : 0,
          period: @settings['period'].present? ? @settings['period'] : 'this_week'
        }
      when :number_of_closed_tickets_with_pending_or_failed_response
        {
          number_of_tickets: @account.tickets.closed
                                             .where(call_center: @call_center)
                                             .where(response_status: [Ticket.response_statuses[:pending], Ticket.response_statuses[:failed]])
                                             .count
        }
      when :number_of_revised_open_tickets
        {
          number_of_tickets: @account.tickets.open.where(call_center: @call_center).where('version_number > 0').count
        }
      when :number_of_open_tickets_with_attachments
        {
          number_of_tickets: @account.tickets.open.where(call_center: @call_center).joins(:attachments).distinct.count
        }
      when :number_of_open_tickets_with_notes
        {
          number_of_tickets: @account.tickets.open.where(call_center: @call_center).joins(:notes).distinct.count
        }
      else
        {}
      end

    results.merge!(call_center: @call_center) if @widget.has_settings?
    results
  end

  def ticket_due_times(collection)
    {
      overdue: number_of_tickets_based_on_due_time(collection, nil, Time.now.in_time_zone),
      today: number_of_tickets_based_on_due_time(collection, Time.now.in_time_zone.beginning_of_day, Time.now.in_time_zone.tomorrow.beginning_of_day),
      tomorrow: number_of_tickets_based_on_due_time(collection, Time.now.in_time_zone.tomorrow.beginning_of_day, (Time.now.in_time_zone.tomorrow + 1.day).beginning_of_day),
      this_week: number_of_tickets_based_on_due_time(collection, Time.now.in_time_zone.at_beginning_of_week, Time.now.in_time_zone.at_beginning_of_week + 1.week),
      next_week: number_of_tickets_based_on_due_time(collection, Time.now.in_time_zone.at_beginning_of_week + 1.week, Time.now.in_time_zone.at_beginning_of_week + 2.weeks),
      later: number_of_tickets_based_on_due_time(collection, Time.now.in_time_zone.at_beginning_of_week + 2.weeks, nil)
    }
  end

  def number_of_tickets_based_on_due_time(collection, due_at_start, due_at_end)
    collection = collection.where('response_due_at >= ?', due_at_start) if due_at_start
    collection = collection.where('response_due_at < ?', due_at_end) if due_at_end
    collection.count
  end

  def total_tickets_vs_closed_tickets_query(ticket_attribute)
    start_time = end_time = nil
    now_in_time_zone = Time.now.in_time_zone

    case @settings['period']
    when 'last_30_days'
      start_time = now_in_time_zone.at_end_of_day - 30.days
      end_time = now_in_time_zone.at_end_of_day
    when 'last_week'
      start_time = now_in_time_zone.at_beginning_of_week - 1.week
      end_time = now_in_time_zone.at_beginning_of_week - 1.day
    when 'this_month'
      start_time = now_in_time_zone.at_beginning_of_month
      end_time = now_in_time_zone.at_end_of_month
    when 'last_month'
      start_time = now_in_time_zone.at_beginning_of_month - 1.month
      end_time = now_in_time_zone.at_beginning_of_month - 1.day
    else
      # this_week, the default
      start_time = now_in_time_zone.at_beginning_of_week
      end_time = now_in_time_zone.at_end_of_week
    end

    Ticket.find_by_sql(["
      WITH tickets_in_time_zone AS (
        SELECT (#{ticket_attribute} AT TIME ZONE 'UTC' AT TIME ZONE :time_zone)::date AS #{ticket_attribute}_date
        FROM tickets
        WHERE account_id = :account_id
          AND call_center_id = :call_center_id
          AND #{ticket_attribute} >= :start_time AND #{ticket_attribute} < :end_time
      )
      SELECT date::date AS #{ticket_attribute}_date, COUNT(tickets_in_time_zone.*)
      FROM generate_series(:start_date::date, :end_date, '1 day') AS date
      LEFT OUTER JOIN tickets_in_time_zone ON (#{ticket_attribute}_date = date)
      GROUP BY date ORDER BY date",
      {
        start_time: start_time,
        end_time: end_time,
        start_date: start_time.to_date,
        end_date: end_time.to_date,
        account_id: @account.id,
        call_center_id: @call_center&.id,
        time_zone: Time.zone.tzinfo.identifier
      }
    ])
  end

end
