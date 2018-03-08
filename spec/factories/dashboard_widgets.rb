# == Schema Information
#
# Table name: dashboard_widgets
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  type_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  settings   :jsonb            not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :dashboard_widget do
    association :user
    type 1
    settings { {x: 0, y: 0} }
  end
end
