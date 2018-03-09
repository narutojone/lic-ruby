#------------------------------------------------------------------------------
USER_DASHBOARD_WIDGETS = {
  1 => {
    partial:       :number_of_users,
    name:          'Number of Users',
    description:   'Counts the number of all active Users (Assignees and Requesters).',
    policy_class:  'User',
    policy_method: :index?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        2,
    multiple:      false
  },
  2 => {
    partial:       :user_roles_pie_chart,
    name:          'User Roles distribution',
    description:   'A pie chart of roles of active Users.',
    policy_class:  'User',
    policy_method: :index?,
    kind:          :chart,
    width:         {sm: 12, lg: 6},
    height:        2,
    multiple:      false
  }
}

#------------------------------------------------------------------------------
TICKET_DASHBOARD_WIDGETS = {
  3 => {
    partial:       :number_of_tickets_assigned_to_me,
    name:          'Number of open Tickets assigned to me',
    description:   'Counts the number of open Tickets assigned to me.',
    policy_class:  'Ticket',
    policy_method: :index?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      false
  },

  4 => {
    partial:       :number_of_assigned_tickets,
    name:          'Number of assigned Tickets',
    description:   'Counts the number of all open assigned Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },

  5 => {
    partial:       :number_of_incoming_tickets,
    name:          'Number of new Tickets',
    description:   'Counts the number of all new (unassigned) Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },

  6 => {
    partial:       :open_ticket_types_pie_chart,
    name:          'Ticket Type distribution',
    description:   'A pie chart of Types of open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :chart,
    width:         {sm: 12, lg: 6},
    height:        2,
    multiple:      true
  },
  7 => {
    partial:       :my_ticket_types_pie_chart,
    name:          'My Ticket Type distribution',
    description:   'A pie chart of Types of my open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index?,
    kind:          :chart,
    width:         {sm: 12, lg: 6},
    height:        2,
    multiple:      false
  },
  8 => {
    partial:       :number_of_tickets_due_today,
    name:          'Number of open Tickets due today',
    description:   'Counts the number of Tickets due today.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  9 => {
    partial:       :number_of_tickets_created_today,
    name:          'Number of Tickets created today',
    description:   'Counts the number of Tickets created today.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  10 => {
    partial:       :number_of_tickets_closed_today,
    name:          'Number of Tickets closed today',
    description:   'Counts the number of Tickets closed today',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  11 => {
    partial:       :number_of_open_tickets_past_due,
    name:          'Number of open Tickets past due',
    description:   'Counts the number of open Tickets whose due time has passed.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  12 => {
    partial:       :open_ticket_types,
    name:          'Number of open Tickets',
    description:   'Counts the number of all open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 12, lg: 6},
    height:        1,
    multiple:      true
  },
  13 => {
    partial:       :open_tickets_by_assignees_pie_chart,
    name:          'Ticket Assignee distribution',
    description:   'A pie chart of Assignees of open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :chart,
    width:         {sm: 12, lg: 6},
    height:        2,
    multiple:      true
  },
  14 => {
    partial:       :my_tickets_due_times,
    name:          'My Ticket due times',
    description:   'Lists the number of my Tickets due today, tomorrow, this week, next week, later and overdue.',
    policy_class:  'Ticket',
    policy_method: :index?,
    kind:          :table,
    width:         {sm: 12, lg: 6},
    height:        3,
    multiple:      false
  },
  15 => {
    partial:       :ticket_due_times,
    name:          'Ticket due times',
    description:   'Lists the number of Tickets due today, tomorrow, this week, next week, later and overdue.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :table,
    width:         {sm: 12, lg: 6},
    height:        3,
    multiple:      true
  },
  16 => {
    partial:       :total_tickets_vs_closed_tickets,
    name:          'Total Tickets vs closed Tickets',
    description:   'Counts the number of open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :chart,
    width:         {sm: 12, lg: 9},
    height:        3,
    multiple:      true
  },
  17 => {
    partial:       :number_of_closed_tickets_with_pending_or_failed_response,
    name:          'Number of closed Tickets with pending or failed response',
    description:   'Counts the number of open Tickets closed Tickets with pending or failed response.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  18 => {
    partial:       :number_of_revised_open_tickets,
    name:          'Number of revised open Tickets',
    description:   'Counts the number of revised open Tickets.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  19 => {
    partial:       :number_of_open_tickets_with_attachments,
    name:          'Number of open Tickets with Attachments',
    description:   'Counts the number of open Tickets that have Attachments.',
    policy_class:  'Ticket',
    policy_method: :index_cc?,
    kind:          :number,
    width:         {sm: 6, lg: 3},
    height:        1,
    multiple:      true
  },
  20 => {
      partial:       :number_of_open_tickets_with_notes,
      name:          'Number of open Tickets with Notes',
      description:   'Counts the number of open Tickets that have Notes.',
      policy_class:  'Ticket',
      policy_method: :index_cc?,
      kind:          :number,
      width:         {sm: 6, lg: 3},
      height:        1,
      multiple:      true
  },
}

#------------------------------------------------------------------------------
DASHBOARD_WIDGETS = {}
DASHBOARD_WIDGETS.merge!(TICKET_DASHBOARD_WIDGETS) { |key, h1, h2| raise }
DASHBOARD_WIDGETS.merge!(USER_DASHBOARD_WIDGETS)   { |key, h1, h2| raise }

DASHBOARD_WIDGETS_BY_NAME = ActiveSupport::HashWithIndifferentAccess.new
DASHBOARD_WIDGETS.each do |id, hash|
  DASHBOARD_WIDGETS_BY_NAME[hash[:partial]] = hash.merge(id: id)
end
