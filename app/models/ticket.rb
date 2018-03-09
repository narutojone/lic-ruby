class Ticket < ApplicationRecord
  enum ticket_type: ['normal', 'design', 'emergency']
  enum response_status: [:pending, :sent, :failed]

  belongs_to :account
  belongs_to :call_center
  belongs_to :assignee, class_name: User.name
  # belongs_to :caller, class_name: ?

  validates_presence_of :account, :call_center

  scope :incoming, ->{where("response_status = ?", self.response_statuses[:pending])}
end
