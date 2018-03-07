require 'simplecov'
SimpleCov.start 'rails' do
  coverage_dir('tmp/coverage')
  add_filter('/spec/')
  add_filter('/config/')
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'pundit/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'webmock/rspec'
require 'vcr'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Require shared examples
Dir[Rails.root.join("spec/models/shared_examples/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/services/shared_examples/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 7
Capybara.configure do |config|
  config.always_include_port = true
end

$now = DateTime.parse('2020-01-01 00:00:01 -0500')

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.ignore_hosts '127.0.0.1', 'company.boss811.test'

  config.hook_into :webmock
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding(disabled: true)

  config.include SampleDocuments
  config.include Helpers::Model,                  type: :model

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Helpers::Controller,             type: :controller

  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Helpers::Controller,             type: :helper

  config.include Helpers::View,                   type: :view
  config.include Devise::Test::ControllerHelpers, type: :view

  config.include Helpers::Feature,                type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with :deletion, {except: %w[spatial_ref_sys]}
  end

  config.before(:each) do |example|
    # Lets use a fixed neutral time zone
    Time.zone = 'Cape Verde Is.' # UTC -1:00

    if example.metadata[:js]
      DatabaseCleaner.strategy = :deletion, {except: %w[spatial_ref_sys]}
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.after(:each) do
    Thread.current[:current_user] = nil
    DatabaseCleaner.clean
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  #----------------------------------------------------------------------------
  def valid_address(attributes = {})
    {
      :first_name => 'John',
      :last_name => 'Doe',
      :address1 => '2010 Cherry Ct.',
      :city => 'Mobile',
      :state => 'AL',
      :zip => '36608',
      :country => 'US'
    }.merge(attributes)
  end

  def valid_card(attributes = {})
    { :first_name => 'Joe',
      :last_name => 'Doe',
      :month => 2,
      :year => Time.now.year + 1,
      :number => '1',
      :brand => 'bogus',
      :verification_value => '123'
    }.merge(attributes)
  end

  def valid_user(attributes = {})
    FactoryGirl.build(:user, attributes).attributes
  end

  def valid_subscription(attributes = {})
    { :plan => FactoryGirl.create(:basic_subscription_plan),
      :account => FactoryGirl.create(:account)
    }.merge(attributes)
  end

  def api_basic_auth_login(email, password)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
  end

  def grant_permission(user, permission)
    permission_id =
      if permission.is_a?(String)
        parts = permission.split(':')
        PERMISSIONS[parts[0]][:activities][parts[1]][:id]
      elsif permission.is_a?(Integer)
        permission
      end

    role = FactoryGirl.create(:role, account: user.account, permissions: [permission_id])
    user.roles << role
  end

  def account_admin(account)
    admin_role = account.roles.find_by(admin: true)
    account.users.joins(:roles_users).where('roles_users.role_id = ?', admin_role.id).first
  end

  #----------------------------------------------------------------------------
  def set_http_referer(path)
    request.env['HTTP_REFERER'] = path
  end
end
