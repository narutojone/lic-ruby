class RolesUser < ApplicationRecord
  belongs_to :role, inverse_of: :roles_users, optional: false
  belongs_to :user, inverse_of: :roles_users, optional: false

end
