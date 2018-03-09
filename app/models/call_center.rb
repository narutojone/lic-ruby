class CallCenter < ApplicationRecord
  has_many :tickets
  has_many :call_centers_users
  has_many :users, through: :call_centers_users

  belongs_to :account

  validates_presence_of :name, :account
end
