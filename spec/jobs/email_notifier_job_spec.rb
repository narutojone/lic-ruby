require 'spec_helper'

RSpec.describe EmailNotifierJob do

  it 'should run the EmailNotifier on the ticket and template' do
    ticket = FactoryGirl.create(:ticket)

    expect(EmailNotifier).to receive_message_chain(:new, :notify)

    EmailNotifierJob.perform_now(ticket, EmailNotification.templates[:ticket_updated])
  end

end
