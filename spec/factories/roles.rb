# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  account_id  :integer          not null
#  name        :string           not null
#  permissions :integer          default([]), not null, is an Array
#  admin       :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    association :account
    name 'Manager role'
  end
end
