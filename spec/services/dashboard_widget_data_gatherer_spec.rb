require 'spec_helper'

# # Many logics about tickets were removed
# describe DashboardWidgetDataGatherer do
#   before do
#     @account = FactoryBot.create(:account)
#     @call_center1 = @account.call_centers.first
#     @call_center2 = FactoryBot.create(:call_center, account: @account)
#
#     @admin = account_admin(@account)
#     @admin.call_centers << @call_center1 << @call_center2
#     @locator = FactoryBot.create(:user, account: @account)
#     @locator.call_centers << @call_center1
#   end
#
#   it ':number_of_users' do
#     @account.subscription.user_limit = 842
#     gatherer = DashboardWidgetDataGatherer.new(@account, @admin, get_widget(:number_of_users, nil))
#     # admin + locator
#     expect(gatherer.data).to eq({number_of_users: 2, account_limit: 842})
#   end
#
#   it ':user_roles_pie_chart' do
#     roles = []
#     3.times { |i| roles << FactoryBot.create(:role, account: @account, name: "Role #{i}") }
#     4.times do |i|
#       FactoryBot.create(:user, account: @account).roles << roles[0]
#     end
#     3.times do |i|
#       FactoryBot.create(:user, account: @account).roles << roles[1]
#     end
#     2.times do |i|
#       user = FactoryBot.create(:user, account: @account)
#       user.roles << roles[2]
#       user.roles << roles[1]
#     end
#     2.times do |i|
#       FactoryBot.create(:user, account: @account)
#     end
#     gatherer = DashboardWidgetDataGatherer.new(@account, @admin, get_widget(:user_roles_pie_chart, nil))
#     role_dist = gatherer.data[:roles]
#     expect(role_dist).not_to be_nil
#     expect(role_dist.length).to eq(4)
#     expect(role_dist[0].role_name).to eq('Role 1')
#     expect(role_dist[0].count).to eq(5)
#     expect(role_dist[1].role_name).to eq('Role 0')
#     expect(role_dist[1].count).to eq(4)
#     expect(role_dist[2].role_name).to eq('Role 2')
#     expect(role_dist[2].count).to eq(2)
#     expect(role_dist[3].role_name).to eq('Admin')
#     expect(role_dist[3].count).to eq(1)
#   end
#
#   it ':number_of_tickets_assigned_to_me' do
#     user1 = FactoryBot.create(:user, account: @account)
#     user2 = FactoryBot.create(:user, account: @account)
#     FactoryBot.create(:ticket, account: @account)
#     FactoryBot.create(:assigned_ticket, account: @account, assignee: user1)
#     FactoryBot.create(:assigned_ticket, account: @account, assignee: user1)
#     FactoryBot.create(:assigned_ticket, account: @account, assignee: user2)
#     FactoryBot.create(:closed_ticket, account: @account, assignee: user1)
#     FactoryBot.create(:closed_ticket, account: @account, assignee: user2)
#     FactoryBot.create(:closed_ticket, account: @account, assignee: user2)
#
#     gatherer = DashboardWidgetDataGatherer.new(@account, user1, get_widget(:number_of_tickets_assigned_to_me, nil))
#     expect(gatherer.data[:number_of_tickets]).to eq(2)
#
#     gatherer = DashboardWidgetDataGatherer.new(@account, user2, get_widget(:number_of_tickets_assigned_to_me, nil))
#     expect(gatherer.data[:number_of_tickets]).to eq(1)
#   end
#
#   describe ':number_of_assigned_tickets' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, assignee: @locator)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @locator)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center2, assignee: @admin)
#     end
#
#     it 'returns number of assigned tickets within the call center' do
#       widget = get_widget(:number_of_assigned_tickets, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(3)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_assigned_tickets, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':number_of_incoming_tickets' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @locator)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#     end
#
#     it 'returns number of incoming tickets within the call center' do
#       widget = get_widget(:number_of_incoming_tickets, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(1)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_incoming_tickets, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':open_ticket_types_pie_chart' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Emergency')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Design')
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#     end
#
#     it 'returns open ticket types within the call center' do
#       widget = get_widget(:open_ticket_types_pie_chart, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#
#       ticket_types = gatherer.data[:ticket_types]
#       expect(ticket_types.length).to eq(3)
#       expect(ticket_types[0].ticket_type).to eq('Normal')
#       expect(ticket_types[0].count).to eq(2)
#       expect(ticket_types[1].ticket_type).to eq('Design')
#       expect(ticket_types[1].count).to eq(1)
#       expect(ticket_types[2].ticket_type).to eq('Emergency')
#       expect(ticket_types[2].count).to eq(1)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:open_ticket_types_pie_chart, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#
#     it 'same is returned with :open_ticket_request_types' do
#       widget = get_widget(:open_ticket_types, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#
#       ticket_types = gatherer.data[:ticket_types]
#       expect(ticket_types.length).to eq(3)
#       expect(ticket_types[0].ticket_type).to eq('Normal')
#       expect(ticket_types[0].count).to eq(2)
#       expect(ticket_types[1].ticket_type).to eq('Design')
#       expect(ticket_types[1].count).to eq(1)
#       expect(ticket_types[2].ticket_type).to eq('Emergency')
#       expect(ticket_types[2].count).to eq(1)
#     end
#   end
#
#   describe ':my_ticket_types_pie_chart' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, assignee: nil, ticket_type: 'Normal')
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, ticket_type: 'Normal')
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, assignee: @locator, ticket_type: 'NORMAL')
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin, ticket_type: 'Damage')
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin, ticket_type: 'Emergency')
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, ticket_type: 'Design')
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @locator, ticket_type: 'Normal')
#     end
#
#     it 'returns my ticket types across all call centers' do
#       widget = get_widget(:my_ticket_types_pie_chart, nil)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#
#       ticket_types = gatherer.data[:ticket_types]
#       expect(ticket_types.length).to eq(3)
#       expect(ticket_types[0].ticket_type).to eq('Design')
#       expect(ticket_types[0].count).to eq(1)
#       expect(ticket_types[1].ticket_type).to eq('Normal')
#       expect(ticket_types[1].count).to eq(1)
#       expect(ticket_types[2].ticket_type).to eq('NORMAL')
#       expect(ticket_types[2].count).to eq(1)
#     end
#   end
#
#   describe ':number_of_tickets_due_today' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 19, 9))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 11, 30, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 11, 30, 17))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 11, 30, 18))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, nil)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 1, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2).update_column(:response_due_at, Time.utc(2015, 12, 1, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 1, 17))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 10))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 11, 30, 18))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 1, 10))
#     end
#
#     it 'returns number of tickets due today within the call center' do
#       widget = get_widget(:number_of_tickets_due_today, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 1, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(2)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(3)
#       end
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_tickets_due_today, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 1, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#   end
#
#   describe ':number_of_tickets_created_today' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 11, 30, 16, 59))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 11, 30, 17))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 1, 16, 59))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2, created_at: Time.utc(2015, 12, 1, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 1, 17))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 1, 18))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 11, 30, 12))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 1, 12))
#     end
#
#     it 'returns number of tickets created today within the call center' do
#       widget = get_widget(:number_of_tickets_created_today, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 1, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(4)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(3)
#       end
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_tickets_created_today, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 1, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#   end
#
#   describe ':number_of_tickets_closed_today' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, closed_at: nil)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, closed_at: nil)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 1, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 1, 17))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 2, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 2, 17))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center2).update_column(:closed_at, Time.utc(2015, 12, 2, 17))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 2, 18))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:closed_at, Time.utc(2015, 12, 3, 12))
#     end
#
#     it 'returns number of tickets closed today within the call center' do
#       widget = get_widget(:number_of_tickets_closed_today, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(3)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(2)
#       end
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_tickets_closed_today, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#   end
#
#   describe ':number_of_open_tickets_past_due' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 10))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 13, 29))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2).update_column(:response_due_at, Time.utc(2015, 12, 2, 13, 29))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 13, 31))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 11, 30))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 3))
#     end
#
#     it 'returns number of tickets past due within the call center' do
#       widget = get_widget(:number_of_open_tickets_past_due, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(2)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:number_of_tickets]).to eq(2)
#       end
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_open_tickets_past_due, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#   end
#
#   describe ':open_ticket_types' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2, ticket_type: 'Normal')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Emergency')
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, ticket_type: 'Design')
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, ticket_type: 'Normal')
#     end
#
#     it 'returns counts of open ticket types within the call center' do
#       widget = get_widget(:open_ticket_types, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       ticket_types = gatherer.data[:ticket_types]
#       expect(ticket_types.length).to eq(3)
#       expect(ticket_types[0].ticket_type).to eq('Normal')
#       expect(ticket_types[0].count).to eq(2)
#       expect(ticket_types[1].ticket_type).to eq('Design')
#       expect(ticket_types[1].count).to eq(1)
#       expect(ticket_types[2].ticket_type).to eq('Emergency')
#       expect(ticket_types[2].count).to eq(1)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:open_ticket_types, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':number_of_open_tickets_by_assignees_pie_chart' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, assignee: @admin)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin)
#     end
#
#     it 'returns counts of open tickets by assignee within the call center' do
#       widget = get_widget(:open_tickets_by_assignees_pie_chart, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       tickets_by_assignees = gatherer.data[:tickets_by_assignees]
#       expect(tickets_by_assignees.length).to eq(2)
#       expect(tickets_by_assignees[0].first_name).to eq(@admin.first_name)
#       expect(tickets_by_assignees[0].last_name).to eq(@admin.last_name)
#       expect(tickets_by_assignees[0].count).to eq(2)
#       expect(tickets_by_assignees[1].first_name).to eq(@locator.first_name)
#       expect(tickets_by_assignees[1].last_name).to eq(@locator.last_name)
#       expect(tickets_by_assignees[1].count).to eq(1)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:open_tickets_by_assignees_pie_chart, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe 'ticket due times table' do
#     before do
#       @user1 = FactoryBot.create(:user, account: @account)
#       @user2 = FactoryBot.create(:user, account: @account)
#       # not assigned
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 10))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1).update_column(:response_due_at, Time.utc(2015, 12, 2, 14))
#       # today
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 2, 10))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 2, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 2, 17))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user2).update_column(:response_due_at, Time.utc(2015, 12, 2, 14))
#       # tomorrow
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 3))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user2).update_column(:response_due_at, Time.utc(2015, 12, 3))
#       # this week
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 5))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 6, 17))
#       # next week
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 9))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 10))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user2).update_column(:response_due_at, Time.utc(2015, 12, 10))
#       # later
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 22))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2500, 1, 1))
#       # closed tickets
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 2, 10))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 2, 14))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @user1).update_column(:response_due_at, Time.utc(2015, 12, 5))
#     end
#
#     it ':my_tickets_due_times' do
#       widget = get_widget(:my_tickets_due_times, nil)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @user1, widget)
#         due_times = gatherer.data
#         expect(due_times[:overdue]).to eq(1)
#         expect(due_times[:today]).to eq(3)
#         expect(due_times[:tomorrow]).to eq(1)
#         expect(due_times[:this_week]).to eq(6)
#         expect(due_times[:next_week]).to eq(2)
#         expect(due_times[:later]).to eq(2)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @user1, widget)
#         due_times = gatherer.data
#         expect(due_times[:overdue]).to eq(1)
#         expect(due_times[:today]).to eq(2)
#         expect(due_times[:tomorrow]).to eq(2)
#         expect(due_times[:this_week]).to eq(5)
#         expect(due_times[:next_week]).to eq(3)
#         expect(due_times[:later]).to eq(2)
#       end
#     end
#
#     it ':ticket_due_times' do
#       widget = get_widget(:ticket_due_times, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         due_times = gatherer.data
#         expect(due_times[:overdue]).to eq(2)
#         expect(due_times[:today]).to eq(6)
#         expect(due_times[:tomorrow]).to eq(1)
#         expect(due_times[:this_week]).to eq(9)
#         expect(due_times[:next_week]).to eq(3)
#         expect(due_times[:later]).to eq(2)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         due_times = gatherer.data
#         expect(due_times[:overdue]).to eq(2)
#         expect(due_times[:today]).to eq(5)
#         expect(due_times[:tomorrow]).to eq(2)
#         expect(due_times[:this_week]).to eq(8)
#         expect(due_times[:next_week]).to eq(4)
#         expect(due_times[:later]).to eq(2)
#       end
#     end
#
#     it ':ticket_due_times does not return data outside of users call centers' do
#       widget = get_widget(:ticket_due_times, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 2, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#   end
#
#   describe ':total_tickets_vs_closed_tickets' do
#     before do
#       other_account = FactoryBot.create(:account)
#
#       # last week
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 6, 17))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 6, 18))
#
#       # this week
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 7, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 7, 16, 59)).update_column(:closed_at, Time.utc(2015, 12, 7, 16, 59))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 7, 17))
#
#       FactoryBot.create(:assigned_ticket, account: other_account, created_at: Time.utc(2015, 12, 9, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, created_at: Time.utc(2015, 12, 9, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, assignee: @locator, created_at: Time.utc(2015, 12, 9, 16, 59))
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, created_at: Time.utc(2015, 12, 9, 17))
#
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, created_at: Time.utc(2015, 12, 10, 10))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 10, 10)).update_column(:closed_at, Time.utc(2015, 12, 10, 10))
#
#       FactoryBot.create(:closed_ticket, account: other_account, created_at: Time.utc(2015, 12, 11, 16, 59)).update_column(:closed_at, Time.utc(2015, 12, 11, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 11, 16, 59)).update_column(:closed_at, Time.utc(2015, 12, 11, 16, 59))
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, created_at: Time.utc(2015, 12, 11, 17))
#
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, assignee: @locator, created_at: Time.utc(2015, 12, 13, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 13, 16, 59)).update_column(:closed_at, Time.utc(2015, 12, 13, 16, 59))
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 13, 17)).update_column(:closed_at, Time.utc(2015, 12, 13, 17))
#
#       # next week
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, assignee: @admin, created_at: Time.utc(2015, 12, 14)).update_column(:closed_at, Time.utc(2015, 12, 14))
#     end
#
#     it 'gathers total vs closed ticket counts for this week within the call center' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         ticket_data = gatherer.data[:total_tickets]
#         expect(ticket_data[0].created_at_date.to_s).to eq('2015-12-07')
#         expect(ticket_data[0].count).to eq(3)
#         expect(ticket_data[1].created_at_date.to_s).to eq('2015-12-08')
#         expect(ticket_data[1].count).to eq(0)
#         expect(ticket_data[2].created_at_date.to_s).to eq('2015-12-09')
#         expect(ticket_data[2].count).to eq(2)
#         expect(ticket_data[3].created_at_date.to_s).to eq('2015-12-10')
#         expect(ticket_data[3].count).to eq(2)
#         expect(ticket_data[4].created_at_date.to_s).to eq('2015-12-11')
#         expect(ticket_data[4].count).to eq(2)
#         expect(ticket_data[5].created_at_date.to_s).to eq('2015-12-12')
#         expect(ticket_data[5].count).to eq(0)
#         expect(ticket_data[6].created_at_date.to_s).to eq('2015-12-13')
#         expect(ticket_data[6].count).to eq(3)
#
#         ticket_data = gatherer.data[:closed_tickets]
#         expect(ticket_data[0].closed_at_date.to_s).to eq('2015-12-07')
#         expect(ticket_data[0].count).to eq(1)
#         expect(ticket_data[1].closed_at_date.to_s).to eq('2015-12-08')
#         expect(ticket_data[1].count).to eq(0)
#         expect(ticket_data[2].closed_at_date.to_s).to eq('2015-12-09')
#         expect(ticket_data[2].count).to eq(0)
#         expect(ticket_data[3].closed_at_date.to_s).to eq('2015-12-10')
#         expect(ticket_data[3].count).to eq(1)
#         expect(ticket_data[4].closed_at_date.to_s).to eq('2015-12-11')
#         expect(ticket_data[4].count).to eq(1)
#         expect(ticket_data[5].closed_at_date.to_s).to eq('2015-12-12')
#         expect(ticket_data[5].count).to eq(0)
#         expect(ticket_data[6].closed_at_date.to_s).to eq('2015-12-13')
#         expect(ticket_data[6].count).to eq(2)
#
#         Time.zone = 'Bangkok' #UTC+7
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         ticket_data = gatherer.data[:total_tickets]
#         expect(ticket_data[0].created_at_date.to_s).to eq('2015-12-07')
#         expect(ticket_data[0].count).to eq(4)
#         expect(ticket_data[1].created_at_date.to_s).to eq('2015-12-08')
#         expect(ticket_data[1].count).to eq(1)
#         expect(ticket_data[2].created_at_date.to_s).to eq('2015-12-09')
#         expect(ticket_data[2].count).to eq(1)
#         expect(ticket_data[3].created_at_date.to_s).to eq('2015-12-10')
#         expect(ticket_data[3].count).to eq(3)
#         expect(ticket_data[4].created_at_date.to_s).to eq('2015-12-11')
#         expect(ticket_data[4].count).to eq(1)
#         expect(ticket_data[5].created_at_date.to_s).to eq('2015-12-12')
#         expect(ticket_data[5].count).to eq(1)
#         expect(ticket_data[6].created_at_date.to_s).to eq('2015-12-13')
#         expect(ticket_data[6].count).to eq(2)
#
#         ticket_data = gatherer.data[:closed_tickets]
#         expect(ticket_data[0].closed_at_date.to_s).to eq('2015-12-07')
#         expect(ticket_data[0].count).to eq(1)
#         expect(ticket_data[1].closed_at_date.to_s).to eq('2015-12-08')
#         expect(ticket_data[1].count).to eq(0)
#         expect(ticket_data[2].closed_at_date.to_s).to eq('2015-12-09')
#         expect(ticket_data[2].count).to eq(0)
#         expect(ticket_data[3].closed_at_date.to_s).to eq('2015-12-10')
#         expect(ticket_data[3].count).to eq(1)
#         expect(ticket_data[4].closed_at_date.to_s).to eq('2015-12-11')
#         expect(ticket_data[4].count).to eq(1)
#         expect(ticket_data[5].closed_at_date.to_s).to eq('2015-12-12')
#         expect(ticket_data[5].count).to eq(0)
#         expect(ticket_data[6].closed_at_date.to_s).to eq('2015-12-13')
#         expect(ticket_data[6].count).to eq(1)
#       end
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center2)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#         expect(gatherer.data).to be_nil
#       end
#     end
#
#     it 'gathers total and closed ticket counts' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:total_tickets_count]).to eq(12)
#         expect(gatherer.data[:closed_tickets_count]).to eq(5)
#       end
#     end
#
#     it 'calculates closed to total tickets percentage' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:closed_to_total_percentage]).to eq(42)
#       end
#     end
#
#     it 'calculates closed to total tickets percentage even if total ticket count is zero' do
#       account = FactoryBot.create(:account)
#       user = account_admin(account)
#       user.call_centers << account.call_centers.first
#
#       widget = get_widget(:total_tickets_vs_closed_tickets, account.call_centers.first)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(account, user, widget)
#         expect(gatherer.data[:closed_to_total_percentage]).to eq(0)
#       end
#     end
#
#     it 'has this week as the default period' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center1)
#
#       Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#         Time.zone = 'UTC'
#         gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#         expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-12-07')
#         expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-12-13')
#       end
#     end
#
#     it 'returns period with the data' do
#       widget = get_widget(:total_tickets_vs_closed_tickets, @call_center1)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:period]).to eq('this_week')
#
#       widget.settings['period'] = 'last_month'
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:period]).to eq('last_month')
#     end
#
#     describe 'period params' do
#       let(:widget) { get_widget(:total_tickets_vs_closed_tickets, @call_center1) }
#
#       it 'accepts last_30_days as a period' do
#         widget.settings['period'] = 'last_30_days'
#
#         Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#           Time.zone = 'UTC'
#           gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#           expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-11-08')
#           expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-12-08')
#         end
#       end
#
#       it 'accepts this_week as a period' do
#         widget.settings['period'] = 'this_week'
#
#         Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#           Time.zone = 'UTC'
#           gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#           expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-12-07')
#           expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-12-13')
#         end
#       end
#
#       it 'accepts last_week as a period' do
#         widget.settings['period'] = 'last_week'
#
#         Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#           Time.zone = 'UTC'
#           gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#           expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-11-30')
#           expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-12-06')
#         end
#       end
#
#       it 'accepts this_month as a period' do
#         widget.settings['period'] = 'this_month'
#
#         Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#           Time.zone = 'UTC'
#           gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#           expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-12-01')
#           expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-12-31')
#         end
#       end
#
#       it 'accepts last_month as a period' do
#         widget.settings['period'] = 'last_month'
#
#         Timecop.freeze(Time.utc(2015, 12, 8, 13, 30)) do
#           Time.zone = 'UTC'
#           gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#           expect(gatherer.data[:total_tickets].first.created_at_date.to_s).to eq('2015-11-01')
#           expect(gatherer.data[:total_tickets].last.created_at_date.to_s).to eq('2015-11-30')
#         end
#       end
#     end
#   end
#
#   describe ':number_of_closed_tickets_with_pending_or_failed_response' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, response_status: :pending)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, response_status: :pending)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :pending)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :sent)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :sent)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :failed)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :failed)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, response_status: :failed)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center2, response_status: :failed)
#     end
#
#     it 'returns count of closed tickets with pending or failed response within the call center' do
#       widget = get_widget(:number_of_closed_tickets_with_pending_or_failed_response, @call_center1)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(4)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_closed_tickets_with_pending_or_failed_response, @call_center2)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':number_of_revised_open_tickets' do
#     before do
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, version_number: 0)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1, version_number: 1)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, version_number: 0)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, version_number: 2)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center1, version_number: 3)
#       FactoryBot.create(:assigned_ticket, account: @account, call_center: @call_center2, version_number: 3)
#       FactoryBot.create(:closed_ticket, account: @account, call_center: @call_center1, version_number: 1)
#     end
#
#     it 'returns count of open revised tickets within the call center' do
#       widget = get_widget(:number_of_revised_open_tickets, @call_center1)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(3)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_revised_open_tickets, @call_center2)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':number_of_open_tickets_with_attachments' do
#     before do
#       ticket1 = FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       ticket2 = FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       ticket3 = FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#
#       VCR.use_cassette_with_file('save sailormoon.jpg') do
#         FactoryBot.create(:attachment, ticket: ticket1)
#       end
#       VCR.use_cassette_with_file('save sailormoon.jpg') do
#         FactoryBot.create(:attachment, ticket: ticket2)
#       end
#       VCR.use_cassette_with_file('save sailormoon.jpg') do
#         FactoryBot.create(:attachment, ticket: ticket3)
#       end
#     end
#
#     it 'returns number of open ticket with attachments within call center' do
#       widget = get_widget(:number_of_open_tickets_with_attachments, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(2)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_open_tickets_with_attachments, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe ':number_of_open_tickets_with_notes' do
#     before do
#       ticket1 = FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       ticket2 = FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       ticket3 = FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center1)
#       FactoryBot.create(:ticket, account: @account, call_center: @call_center2)
#
#       FactoryBot.create(:note, ticket: ticket1)
#       FactoryBot.create(:note, ticket: ticket2)
#       FactoryBot.create(:note, ticket: ticket3)
#     end
#
#     it 'returns number of open ticket with notes within call center' do
#       widget = get_widget(:number_of_open_tickets_with_notes, @call_center1)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:number_of_tickets]).to eq(2)
#     end
#
#     it 'does not return data outside of users call centers' do
#       widget = get_widget(:number_of_open_tickets_with_notes, @call_center2)
#       gatherer = DashboardWidgetDataGatherer.new(@account, @locator, widget)
#       expect(gatherer.data).to be_nil
#     end
#   end
#
#   describe 'including call center name with data' do
#     it 'includes call center when widget has settings and call center is set' do
#       widget = get_widget(:number_of_revised_open_tickets, @call_center1)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:call_center]).to eq(@call_center1)
#     end
#
#     it 'does not include call center when widget does not have settings' do
#       widget = get_widget(:number_of_users, nil)
#
#       gatherer = DashboardWidgetDataGatherer.new(@account, @admin, widget)
#       expect(gatherer.data[:call_center]).to be_nil
#     end
#   end
#
#   private
#
#   def get_widget(partial, call_center, settings = {})
#     DashboardWidget.new(type_id: DASHBOARD_WIDGETS.find { |key, val| val[:partial] == partial}[0], call_center: call_center, settings: settings)
#   end
# end
