class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, authentication_keys: [:email]

  attribute :time_zone, :string, default: 'Eastern Time (US & Canada)'

  has_many :roles_users,        inverse_of: :user, dependent: :destroy
  has_many :roles,              through: :roles_users, dependent: :destroy
  has_many :dashboard_widgets,  -> { order("settings->'y', settings->'x', type_id") }, dependent: :delete_all

  validates_uniqueness_of :email

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 8..128, allow_blank: true

  validates_presence_of :time_zone
  validates_inclusion_of :active, in: [true, false], allow_nil: false

  scope :is_active, ->(bool = true) { where(active: bool) }
  scope :order_by_name, -> { order(:last_name, :first_name) }

  def name
    if last_name.present?
      "#{first_name} #{last_name}"
    else
     first_name
    end
  end

  def has_permission?(resource, activity)
    roles.each do |role|
      return true if role.admin? || role.permissions.include?(PERMISSIONS[resource][:activities][activity][:id])
    end
    false
  end

  # Devise authentication
  def active_for_authentication?
    super && active?
  end

  # Devise authentication
  def inactive_message
    active? ? super : :deactivated
  end

  def admin?
    self.roles.exists?(admin: true)
  end

  protected

  def password_required?
    password.present? || password_confirmation.present?
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    %w(first_name last_name email active) + _ransackers.keys
  end

end
