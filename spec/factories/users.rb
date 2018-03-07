# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  account_id             :integer          not null
#  email                  :string           not null
#  encrypted_password     :string           not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  api_key                :string
#  time_zone              :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(TRUE), not null
#

FactoryGirl.define do
  factory :user, aliases: [:assignee, :respondent] do
    first_name 'John'
    last_name 'Doe'
    sequence(:email) { |n| "john_doe_#{n}@mailinator.net" }
    account
    password 'foobar123'
    password_confirmation 'foobar123'
  end
end
