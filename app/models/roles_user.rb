class RolesUser < ApplicationRecord
  belongs_to :role, inverse_of: :roles_users, optional: false
  belongs_to :user, inverse_of: :roles_users, optional: false

  validate :enforce_the_same_account

  private

  def enforce_the_same_account
    if self.role && self.user && self.role.account_id != self.user.account_id
      self.errors.add(:role_id, "not from the same account with user")
    end
  end
end
