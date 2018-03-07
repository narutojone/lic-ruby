require 'spec_helper'

describe ApplicationPolicy do
  subject { described_class }

  before(:each) do
    @account = FactoryGirl.create(:account)
    @user = FactoryGirl.create(:user, account: @account)
  end

  permissions :index?, :show?, :edit?, :update?, :create?, :destroy? do
    it 'denies access by default' do
      grant_permission(@user, -1)
      expect(subject).not_to permit(@user, Object.new)
    end
  end
end
