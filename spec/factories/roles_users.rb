FactoryBot.define do
  factory :roles_user do
    user
    role { user.account.roles.first }
  end
end
