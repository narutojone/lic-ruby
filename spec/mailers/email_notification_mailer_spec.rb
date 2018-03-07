require 'spec_helper'

RSpec.describe EmailNotificationMailer do
  let(:recipient) { FactoryGirl.create(:user) }

  describe '#notification' do
    before do
      header = 'Hello, Kitty ^_^'
      footer = 'Sincerely, BOSS811 Team'
      @mail = EmailNotificationMailer.notification(recipient, 'notification subject', 'notification text', header, footer)
    end

    it 'sends from noreply@boss811.com' do
      expect(@mail.from).to eq(['noreply@boss811.com'])
    end

    it 'sends to the recipient' do
      expect(@mail.to).to eq([recipient.email])
    end

    it 'has a subject' do
      expect(@mail.subject).to eq('notification subject')
    end

    it 'has a text' do
      expect(@mail.body.to_s).to include("notification text\n")
    end

    it 'has a email header' do
      expect(@mail.body.to_s).to include("Hello, Kitty")
    end

    it 'has a email footer' do
      expect(@mail.body.to_s).to include("BOSS811 Team")
    end
  end

end
