class SubscriptionNotifierPreview < ActionMailer::Preview
  ActionMailer::Base.default_url_options[:host] = 'test.local'

  def charge_failure
    SubscriptionNotifierMailer.charge_failure(Account.first.subscription)
  end

  def charge_receipt
    payment = SubscriptionPayment.new(subscription: Account.first.subscription, amount: 9.99)
    SubscriptionNotifierMailer.charge_receipt(payment)
  end

  def misc_receipt
    payment = SubscriptionPayment.new(subscription: Account.first.subscription, amount: 7.99)
    SubscriptionNotifierMailer.misc_receipt(payment)
  end

  def plan_changed
    SubscriptionNotifierMailer.plan_changed(Account.first.subscription)
  end

  def setup_receipt
    payment = SubscriptionPayment.new(subscription: Account.first.subscription, amount: 8.99)
    SubscriptionNotifierMailer.setup_receipt(payment)
  end

  def trial_expiring
    SubscriptionNotifierMailer.trial_expiring(Account.first.subscription)
  end

  def welcome
    SubscriptionNotifierMailer.welcome(Account.first)
  end

end
