class Subscription < ApplicationRecord
  belongs_to :account

  validates_presence_of :account
  validates_uniqueness_of :account_id
end
