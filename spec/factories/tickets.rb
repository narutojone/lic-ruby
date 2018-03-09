FactoryBot.define do
  factory :ticket do
    account
    association :assignee, factory: :user
    call_center

    ticket_type "normal"
    response_status :pending
  end
end
