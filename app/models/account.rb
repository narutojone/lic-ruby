class Account < ApplicationRecord
  has_many :users
  has_many :roles

  validates_presence_of :name
  validates_uniqueness_of :domain

  before_create :generate_subdomain, :set_default_time_zone
  after_create :create_default_admin

  def self.find_by_subdomain(subdomain)
    self.where("LOWER(domain) = ?", subdomain.try(:downcase)).first
  end

  def reached_user_limit?
    false
  end

  private

  # We may need to black list some subdomain
  def generate_subdomain
    slug = self.name.gsub(/\W/, "-").gsub(/\-{2,}/, "-").sub(/^\-/, "").sub(/\-$/, "").downcase
    count = self.class.where(domain: slug).count

    while count > 0
      slug = "#{slug}-#{count + 1}"
      count = self.class.where(domain: slug).count
    end

    self.domain = slug
  end

  def set_default_time_zone
    self.time_zone ||= Time.zone.name
  end

  def create_default_admin
    role = self.roles.create!(name: "Admin", admin: true)
    password = SecureRandom.hex(8)

    user = self.users.create!(
      email: "#{self.domain}@example.com",
      active: false,
      time_zone: self.time_zone,
      password: password,
      password_confirmation: password
    )

    user.roles_users.create!(role: role)
  end
end
