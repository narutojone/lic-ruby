require 'spec_helper'

# # Some templates were removed
# describe EmailNotifier do
#   before do
#     @account = FactoryBot.create(:account, domain: 'yyy', email_header: 'Hello, Kitty', email_footer: 'BOSS811 Team')
#     @admin = account_admin(@account)
#     @ticket = FactoryBot.create(:ticket, account: @account)
#     @audit_with_missing = FactoryBot.create(:audit, account: @account, missed_ticket_numbers: ['11205-246-008', '11205-400-004'])
#
#     @email_notification = FactoryBot.create(:email_notification,
#                                              account: @account,
#                                              enabled: true,
#                                              template: EmailNotification.templates[:new_ticket_when_assigned],
#                                              notifiable_role: nil,
#                                              notifiable_user: nil,
#                                              notify_assignee: false)
#   end
#
#   #----------------------------------------------------------------------------
#   describe '#initialize' do
#     it 'load email notification settings based on template' do
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#       expect(notifier.instance_variable_get(:@notification)).to eq(@email_notification)
#       expect(notifier.instance_variable_get(:@account)).to eq(@ticket.account)
#
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_closed])
#       expect(notifier.instance_variable_get(:@notification)).to eq(nil)
#     end
# 	end
#
#   #----------------------------------------------------------------------------
#   describe '#recipients' do
#     context 'users as recipients' do
#       it 'returns an array of recipients' do
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients).is_a?(Array)).to eq(true)
#       end
#
#       it 'returns all role users when notifiable_role has been set' do
#         role1 = FactoryBot.create(:role, account: @account)
#         role2 = FactoryBot.create(:role, account: @account)
#         user1 = FactoryBot.create(:user, account: @account)
#         user1.roles << role1 << role2
#         user2 = FactoryBot.create(:user, account: @account)
#         user2.roles << role1
#         user3 = FactoryBot.create(:user, account: @account)
#         user3.roles << role2
#
#         @email_notification.update_attribute(:notifiable_role, role1)
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to contain_exactly(user1, user2)
#       end
#
#       it 'returns the user when notifiable_user has been set' do
#         user1 = FactoryBot.create(:user, account: @account)
#         user2 = FactoryBot.create(:user, account: @account)
#
#         @email_notification.update_attribute(:notifiable_user, user2)
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([user2])
#       end
#
#       it 'returns the ticket assignee when notify_assignee is true' do
#         user1 = FactoryBot.create(:user, account: @account)
#         user2 = FactoryBot.create(:user, account: @account)
#
#         @email_notification.update_attribute(:notify_assignee, true)
#         @ticket.assignee = user1
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([user1])
#       end
#
#       it 'does not return the ticket assignee when notify_assignee is false' do
#         user1 = FactoryBot.create(:user, account: @account)
#
#         @email_notification.update_attribute(:notify_assignee, false)
#         @ticket.assignee = user1
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([])
#       end
#
#       it 'does not return the ticket assignee when there is no assignee' do
#         @email_notification.update_attribute(:notify_assignee, true)
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([])
#       end
#
#       it 'returns all users when multiple recipients are selected' do
#         role1 = FactoryBot.create(:role, account: @account)
#         role2 = FactoryBot.create(:role, account: @account)
#         user1 = FactoryBot.create(:user, account: @account)
#         user1.roles << role1 << role2
#         user2 = FactoryBot.create(:user, account: @account)
#         user2.roles << role1
#         user3 = FactoryBot.create(:user, account: @account)
#         user3.roles << role2
#
#         @email_notification.update_attribute(:notifiable_role, role1)
#         @email_notification.update_attribute(:notifiable_user, user2)
#         @email_notification.update_attribute(:notify_assignee, true)
#         @ticket.assignee = user3
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to contain_exactly(user1, user2, user3)
#       end
#
#       it 'does not return the same user twice' do
#         user1 = FactoryBot.create(:user, account: @account)
#         user2 = FactoryBot.create(:user, account: @account)
#
#         @email_notification.update_attribute(:notifiable_user, user1)
#         @email_notification.update_attribute(:notify_assignee, true)
#         @ticket.assignee = user1
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([user1])
#       end
#
#       it 'does not return inactive users' do
#         role1 = FactoryBot.create(:role, account: @account)
#         user1 = FactoryBot.create(:user, account: @account, active: false)
#         user1.roles << role1
#         user2 = FactoryBot.create(:user, account: @account, active: false)
#         user3 = FactoryBot.create(:user, account: @account, active: false)
#
#         @email_notification.update_attribute(:notifiable_role, role1)
#         @email_notification.update_attribute(:notifiable_user, user2)
#         @email_notification.update_attribute(:notify_assignee, true)
#         @ticket.assignee = user3
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect(notifier.send(:recipients)).to eq([])
#       end
#     end
#
#     context 'excavator as recipient' do
#       before do
#         FactoryBot.create(:email_notification,
#           account: @account,
#           enabled: true,
#           template: EmailNotification.templates[:excavator_notification_after_ticket_close],
#           notifiable_role: nil,
#           notifiable_user: nil,
#           notify_assignee: false)
#         @ticket.excavator_contact_email = 'excavator@example.com'
#         @notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:excavator_notification_after_ticket_close])
#       end
#
#       it 'returns the excavator as recipient' do
#         recipients = @notifier.send(:recipients)
#         expect(recipients.length).to eq(1)
#         expect(recipients[0].email).to eq('excavator@example.com')
#         expect(recipients[0].first_name).to eq('')
#       end
#
#       it 'does not try to include the excavator as recipient when excavator contact email is missing' do
#         @ticket.excavator_contact_email = nil
#         expect(@notifier.send(:recipients).length).to eq(0)
#       end
#     end
#
#     context 'user welcome notification' do
#       before do
#         FactoryBot.create(:email_notification,
#           account: @account,
#           enabled: true,
#           template: EmailNotification.templates[:user_welcome],
#           notifiable_role: nil,
#           notifiable_user: @admin,
#           notify_assignee: true)
#         @new_user = FactoryBot.create(:user, account: @account)
#         @notifier = EmailNotifier.new(@new_user, EmailNotification.templates[:user_welcome])
#       end
#
#       it 'returns the user as the only recipient' do
#         recipients = @notifier.send(:recipients)
#         expect(recipients.length).to eq(1)
#         expect(recipients[0]).to eq(@new_user)
#       end
#
#       it 'returns no recipients when the user is inactive' do
#         @new_user.active = false
#         recipients = @notifier.send(:recipients)
#         expect(recipients.length).to eq(0)
#       end
#     end
#
#     context 'user password reset notification' do
#       before do
#         FactoryBot.create(:email_notification,
#           account: @account,
#           enabled: true,
#           template: EmailNotification.templates[:user_password_reset],
#           notifiable_role: nil,
#           notifiable_user: @admin,
#           notify_assignee: true)
#         @new_user = FactoryBot.create(:user, account: @account)
#         @notifier = EmailNotifier.new(@new_user, EmailNotification.templates[:user_password_reset])
#       end
#
#       it 'returns the user as the only recipient' do
#         recipients = @notifier.send(:recipients)
#         expect(recipients.length).to eq(1)
#         expect(recipients[0]).to eq(@new_user)
#       end
#
#       it 'returns no recipients when the user is inactive' do
#         @new_user.active = false
#         recipients = @notifier.send(:recipients)
#         expect(recipients.length).to eq(0)
#       end
#     end
#   end
#
#   describe '#notify' do
#     before do
#       @email_notification.update_attribute(:notifiable_user, @admin)
#     end
#
#     it 'does not send any emails when the notification is disabled' do
#       @email_notification.update_attribute(:enabled, false)
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#       expect { notifier.notify}.not_to change { ActionMailer::Base.deliveries.size }
#     end
#
#     it 'sends emails when notification is enabled' do
#       @email_notification.update_attribute(:enabled, true)
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#
#       expect { notifier.notify}.to change { ActionMailer::Base.deliveries.size }.by(1)
#       mail = ActionMailer::Base.deliveries.last
#       expect(mail.to).to eq([@admin.email])
#       expect(mail.subject).to eq('A notification')
#     end
#
#     it 'sends each email individually' do
#       role1 = FactoryBot.create(:role, account: @account)
#       user1 = FactoryBot.create(:user, account: @account)
#       user1.roles << role1
#       user2 = FactoryBot.create(:user, account: @account)
#       user2.roles << role1
#       user3 = FactoryBot.create(:user, account: @account)
#
#       @email_notification.update_attribute(:notifiable_role, role1)
#       @email_notification.update_attribute(:notifiable_user, user2)
#       @email_notification.update_attribute(:notify_assignee, true)
#       @ticket.assignee = user3
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#       expect {
#         notifier.notify
#       }.to change { ActionMailer::Base.deliveries.size }.by(3)
#     end
#
#     it 'does not try to find recipients when notification was not found' do
#       notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_closed])
#       expect(notifier).not_to receive(:recipients)
#       notifier.notify
#     end
#
#     describe 'creating EventLog records' do
#       it 'creates an EventLog record when there are recipients' do
#         @email_notification.update_attribute(:notify_assignee, true)
#         locator = FactoryBot.create(:user, account: @account)
#         @ticket.update_attribute(:assignee_id, locator.id)
#
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect {
#           notifier.notify
#         }.to change { EventLog.count }.by(1)
#
#         log = EventLog.last
#         expect(log.email_notification?).to eq(true)
#         expect(log.object).to eq(@ticket)
#         expect(log.data).to eq({'template' => 'new_ticket_when_assigned', 'recipient_emails' => [@admin.email, locator.email]})
#       end
#
#       it 'does not create an EventLog record when there are no recipients' do
#         @email_notification.update_attribute(:notifiable_user, nil)
#
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         expect {
#           notifier.notify
#         }.to_not change { EventLog.count }
#       end
#
#       it 'does not create an EventLog record when model is an Audit' do
#         notifier = EmailNotifier.new(@audit_with_missing, EmailNotification.templates[:failed_audit_notification])
#         expect {
#           notifier.notify
#         }.to_not change { EventLog.count }
#       end
#     end
#
#     describe 'sending the correct emails' do
#       before do
#         ActionMailer::Base.deliveries.clear
#         @email_notification.update_attribute(:notifiable_user, @admin)
#       end
#
#       it 'sends new_ticket_when_assigned email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:new_ticket_when_assigned],
#           subject: 'new_ticket_when_assigned subject, ticket {{ticket.ticket_number}}',
#           text: 'new_ticket_when_assigned text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_assigned])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("new_ticket_when_assigned subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("new_ticket_when_assigned text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends new_ticket_when_unassigned email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:new_ticket_when_unassigned],
#           subject: 'new_ticket_when_unassigned subject, ticket {{ticket.ticket_number}}',
#           text: 'new_ticket_when_unassigned text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_when_unassigned])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("new_ticket_when_unassigned subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("new_ticket_when_unassigned text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends new_ticket_closed email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:new_ticket_closed],
#           subject: 'new_ticket_closed subject, ticket {{ticket.ticket_number}}',
#           text: 'new_ticket_closed text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_ticket_closed])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("new_ticket_closed subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("new_ticket_closed text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends ticket_assigned email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:ticket_assigned],
#           subject: 'ticket_assigned subject, ticket {{ticket.ticket_number}}',
#           text: 'ticket_assigned text, ticket {{ticket.ticket_number}}'
#         )
#         @ticket.assignee = @admin
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_assigned])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("ticket_assigned subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("ticket_assigned text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends ticket_updated email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:ticket_updated],
#           subject: 'ticket_updated subject, ticket {{ticket.ticket_number}}',
#           text: 'ticket_updated text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_updated])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("ticket_updated subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("ticket_updated text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends note_added_to_ticket email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:note_added_to_ticket],
#           subject: 'note_added_to_ticket subject, ticket {{ticket.ticket_number}}',
#           text: 'note_added_to_ticket text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:note_added_to_ticket])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("note_added_to_ticket subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("note_added_to_ticket text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends ticket_closed email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:ticket_closed],
#           subject: 'ticket_closed subject, ticket {{ticket.ticket_number}}',
#           text: 'ticket_closed text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_closed])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("ticket_closed subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("ticket_closed text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends new_revised_ticket email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:new_revised_ticket],
#           subject: 'new_revised_ticket subject, ticket {{ticket.ticket_number}}',
#           text: 'new_revised_ticket text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_revised_ticket])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("new_revised_ticket subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("new_revised_ticket text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends new_emergency_ticket email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:new_emergency_ticket],
#           subject: 'new_emergency_ticket subject, ticket {{ticket.ticket_number}}',
#           text: 'new_emergency_ticket text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:new_emergency_ticket])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("new_emergency_ticket subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("new_emergency_ticket text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends excavator_notification_after_ticket_close email when the notification template is the same' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:excavator_notification_after_ticket_close],
#           subject: 'excavator_notification_after_ticket_close subject, ticket {{ticket.ticket_number}}',
#           text: 'excavator_notification_after_ticket_close text, ticket {{ticket.ticket_number}}'
#         )
#         notifier = EmailNotifier.new(@ticket, EmailNotification.templates[:excavator_notification_after_ticket_close])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq("excavator_notification_after_ticket_close subject, ticket #{@ticket.ticket_number}")
#         expect(mail.body.to_s).to include("excavator_notification_after_ticket_close text, ticket #{@ticket.ticket_number}\n")
#       end
#
#       it 'sends failed audit notification when it has missing tickets' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:failed_audit_notification],
#           subject: 'New failed audit',
#           text: 'New audit failed for the following tickets {{audit.missed_ticket_numbers}}'
#         )
#         notifier = EmailNotifier.new(@audit_with_missing, EmailNotification.templates[:failed_audit_notification])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq('New failed audit')
#         @audit_with_missing.missed_ticket_numbers.each { |a| expect(mail.body.to_s).to include("* #{a}") }
#       end
#
#       it 'sends user welcome notification when creating a new user' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:user_welcome],
#           subject: 'Account created at {{company.name}}',
#           text: 'New account "{{company.name}}" created.'
#         )
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_welcome])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq('Account created at BOSS')
#         expect(mail.body.to_s).to include('New account "BOSS" created.')
#       end
#
#       it 'sends user password reset notification when requested' do
#         @email_notification.update_attributes(
#           template: EmailNotification.templates[:user_password_reset],
#           subject: 'Password reset requested at {{company.name}}',
#           text: 'New password at "{{company.name}}" created.'
#         )
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_password_reset])
#         notifier.notify
#         mail = ActionMailer::Base.deliveries.last
#         expect(mail.subject).to eq('Password reset requested at BOSS')
#         expect(mail.body.to_s).to include('New password at "BOSS" created.')
#       end
#     end
#   end
#
#   describe '#convert_placeholders_to_data' do
#     let(:notifier) { EmailNotifier.new(@ticket, EmailNotification.templates[:ticket_closed]) }
#     let(:recipient) { FactoryBot.create(:user, first_name: 'Jack', last_name: 'Pot') }
#
#     it 'converts {{recipient.first_name}} to recipients first name' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.first_name}} Text')).to eq('Text Jack Text')
#     end
#
#     it 'converts {{recipient.name}} to recipients name' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.name}} Text')).to eq('Text Jack Pot Text')
#     end
#
#     describe '{{recipient.create_password_url}}' do
#       it 'converts placeholder to recipients create password url' do
#         expect(@admin).to receive(:set_reset_password_token).and_return('abc123dfg987')
#
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_welcome])
#
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.create_password_url}} Text')).
#           to eq('Text https://yyy.boss811.test/users/password/edit?create=true&reset_password_token=abc123dfg987 Text')
#       end
#
#       it 'does not try to convert to recipients create password url if the target model is not User' do
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.create_password_url}} Text')).to eq('Text {{recipient.create_password_url}} Text')
#       end
#
#       it 'does not generate a new token for the User if there is no {{recipient.create_password_url}} placeholder present' do
#         expect(@admin).to_not receive(:set_reset_password_token)
#
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_welcome])
#
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text')).to eq('Text')
#       end
#     end
#
#     describe '{{recipient.reset_password_url}}' do
#       it 'converts placeholder to recipients reset password url' do
#         expect(@admin).to receive(:set_reset_password_token).and_return('abc123dfg987')
#
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_password_reset])
#
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.reset_password_url}} Text')).
#           to eq('Text https://yyy.boss811.test/users/password/edit?reset_password_token=abc123dfg987 Text')
#       end
#
#       it 'does not try to convert to recipients reset password url if the target model is not User' do
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.reset_password_url}} Text')).to eq('Text {{recipient.reset_password_url}} Text')
#       end
#
#       it 'does not generate a new token for the User if there is no {{recipient.reset_password_url}} placeholder present' do
#         expect(@admin).to_not receive(:set_reset_password_token)
#
#         notifier = EmailNotifier.new(@admin, EmailNotification.templates[:user_password_reset])
#
#         expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text')).to eq('Text')
#       end
#     end
#
#     it 'converts {{ticket.request_number}} to tickets request number' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.ticket_number}} Text')).to eq("Text #{@ticket.ticket_number} Text")
#     end
#
#     it 'converts {{ticket.url}} to tickets URL' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.url}} Text')).
#         to eq("Text https://#{@ticket.account.full_domain}/tickets/#{@ticket.id} Text")
#     end
#
#     it 'converts {{ticket.assignee.name}} to ticket assignees full name' do
#       assignee = FactoryBot.create(:user, account: @ticket.account, first_name: 'Phil', last_name: 'Bill')
#       @ticket.assignee = assignee
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.assignee.name}} Text')).to eq("Text Phil Bill Text")
#     end
#
#     it 'converts {{ticket.assignee.name}} to empty string if ticket has no assignees' do
#       @ticket.assignee = nil
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.assignee.name}} Text')).to eq("Text  Text")
#     end
#
#     it 'converts {{ticket.work.address}} to tickets work address' do
#       @ticket.work_street = '123 Friartree Lane'
#       @ticket.work_city   = 'Portsmouth'
#       @ticket.work_county = 'Bleightonvilleshire'
#       @ticket.work_state  = 'GT'
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.work.address}} Text')).
#         to eq("Text 123 Friartree Lane, Portsmouth, Bleightonvilleshire, GT Text")
#     end
#
#     it 'converts {{ticket.caller.name}} to tickets caller name' do
#       @ticket.caller_name = 'Al Dente'
#
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.caller.name}} Text')).to eq("Text Al Dente Text")
#     end
#
#     it 'converts {{ticket.caller.phone}} to tickets caller name' do
#       @ticket.caller_phone = '+404 500 422 200 301'
#
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.caller.phone}} Text')).to eq("Text +404 500 422 200 301 Text")
#     end
#
#     it 'converts {{ticket.locate_instructions}} to tickets locate instructions' do
#       @ticket.locate_instructions = 'Locate, yo! Othrwize I will locate on your locate.'
#
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{ticket.locate_instructions}} Text')).to eq('Text Locate, yo! Othrwize I will locate on your locate. Text')
#     end
#
#     it 'converts {{ticket.response_codes}} to a list of ticket response codes' do
#       @ticket.ticket_responses << FactoryBot.create(:ticket_response, service_area: 'FOR104', code: '8A', comment: 'A comment here')
#       @ticket.ticket_responses << FactoryBot.create(:ticket_response, service_area: 'FOR105', code: '1C')
#
#       DefaultResponseCodesCreationJob.perform_now(@ticket.call_center)
#
#       expect(notifier.send(:convert_placeholders_to_data, recipient, "Text\n{{ticket.response_codes}}\nText\n")).to eq(<<-STR
# Text
# * FOR104: 8A - Sewer facilities and sewer laterals marked. (A comment here)<br>* FOR105: 1C - Marked: Permanent Marker Present.
# Text
#       STR
#       )
#     end
#
#     it 'converts {{boss811.logo}} to Boss811 logo' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, '{{boss811.logo}}')).
#         to match(/<img alt="Boss811 Logo" height="30" class="logo" style="display: block;" src="https:\/\/public.boss811.com\//)
#     end
#
#     it 'converts {{company.name}} to account name' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{company.name}} Text')).to eq("Text BOSS Text")
#     end
#
#     it 'converts {{company.logo}} to account logo' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, '{{company.logo}}')).to match(/\A\<img/)
#     end
#
#     it 'converts {{company.boss811_url}} to account url' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, '{{company.boss811_url}}')).to eq('https://yyy.boss811.test/')
#     end
#
#     it 'converts multiple instances of the same placeholder' do
#       expect(notifier.send(:convert_placeholders_to_data, recipient, 'Text {{recipient.first_name}} Text {{recipient.first_name}} Text')).to eq('Text Jack Text Jack Text')
#     end
#   end
#
# end
