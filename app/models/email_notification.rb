class EmailNotification < ApplicationRecord
  LICENSE_TEMPLATES = {
    license_issued: 0,
    license_expired: 1,
    license_expiry_reminder: 2
  }
  TRIAL_TEMPLATES = {
    trial_expiry: 3,
    trial_issued: 4,
    trial_started: 5,
    trial_extended: 6
  }
  USER_TEMPLATES = {
    user_welcome: 7,
    user_password_reset: 8
  }
  TEMPLATES = LICENSE_TEMPLATES.merge(TRIAL_TEMPLATES).merge(USER_TEMPLATES)

  enum template: TEMPLATES

  belongs_to :notifiable_role, class_name: 'Role', optional: true
  belongs_to :notifiable_user, class_name: 'User', optional: true

  validates :template, presence: true
  validates :subject,  presence: true
  validates :text,     presence: true
  validates :enabled,  inclusion: {in: [true, false]}

  html_string :text

end
