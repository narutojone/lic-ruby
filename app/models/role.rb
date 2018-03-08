class Role < ApplicationRecord
  has_many :roles_users, inverse_of: :role
  has_many :users, through: :roles_users

  belongs_to :account

  validates_presence_of :name
  validates_length_of :permissions, minimum: 0, allow_nil: false

  before_save :clean_permissions
  before_destroy :check_if_user_has_role

  private

  def clean_permissions
    return unless will_save_change_to_permissions? && !permissions.nil?
    permission_ids = []
    PERMISSIONS.each_value do |attrs|
      attrs[:activities].each_value do |id_and_label|
        permission_ids << id_and_label[:id]
      end
    end
    self.permissions = self.permissions.compact.select { |p| p.to_i > 0 && permission_ids.include?(p) }.uniq
  end

  def check_if_user_has_role
    return if account.users.joins(:roles_users).where('roles_users.role_id = ?', id).count == 0
    errors.add(:base, 'Can not delete a Role when a User with this Role exists!')
    throw(:abort)
  end

end
