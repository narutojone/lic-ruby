# == Schema Information
#
# Table name: email_notifications
#
#  id                 :integer          not null, primary key
#  account_id         :integer          not null
#  template           :integer          default("new_ticket_when_assigned"), not null
#  enabled            :boolean          default(FALSE), not null
#  notifiable_role_id :integer
#  notifiable_user_id :integer
#  notify_assignee    :boolean          default(FALSE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  subject            :string           not null
#  text               :text             not null
#

FactoryBot.define do
  factory :email_notification do
    association :account
    call_center { account.call_centers.first }
    template 0
    enabled true
    notifiable_role { account.roles.first }
    notifiable_user { account.users.first }
    notify_assignee true
    subject 'A notification'
    text 'Message text ahoi!'
  end
end
