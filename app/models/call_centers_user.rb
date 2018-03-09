class CallCentersUser < ApplicationRecord
  belongs_to :call_center
  belongs_to :user

  validates_uniqueness_of :call_center_id, scope: :user_id
  validate :enforce_the_same_account

  private

  def enforce_the_same_account
    if self.call_center && self.user && self.call_center.account_id != self.user.account_id
      self.errors.add(:call_center_id, "not from the same account with user")
    end
  end
end
