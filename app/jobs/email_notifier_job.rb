class EmailNotifierJob < ApplicationJob
  def perform(model, template)
    EmailNotifier.new(model, template).notify
  end
end
