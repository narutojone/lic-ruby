# Preview all emails at http://localhost:3000/rails/mailers/feedback
class FeedbackPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/feedback/notify
  def notify
    feedback = FactoryGirl.build(:feedback, category: 'bug_report', user: Account.first.users.first)
    FeedbackMailer.notify(feedback)
  end
end
