class TicketRoutingMailerPreview < ActionMailer::Preview
  ActionMailer::Base.default_url_options[:host] = 'test.local'

  def ticket_assigned
    ticket = Ticket.assigned.first
    TicketRoutingMailer.ticket_assigned(ticket)
  end

  def new_ticket
    ticket = Ticket.incoming.first
    user = ticket.account.users.first
    TicketRoutingMailer.new_ticket(ticket, user)
  end

end