# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Steps to get started:

1. From console, run `Account.create!(:name => "test")`, this will create an account with `test` subdomain, an admin with `test@example.com` email

2. `user = User.last`

3. `user.update_attributes!(:password => "12341234")` - This command set password of `test@example.com` to `12341234`

4. Update `hosts` file to point `test.<domain>` to your local, for example `test.lvh.me`. You can then use `test@example.com/12341234` to login.

5. On rails console, run `dw = DashboardWidget.create!(:user_id => u.id, type: 1, settings: {"x" => 0, "y" => 0})` to create a sample widget. For now, I only tested `number_of_users` widget.
