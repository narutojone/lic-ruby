# == Schema Information
#
# Table name: dashboard_widgets
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  type_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  settings   :jsonb            not null
#

require 'spec_helper'

RSpec.describe DashboardWidget do

  before do
    @account = FactoryGirl.create(:account)
    @admin = account_admin(@account)

    @widget = FactoryGirl.create(:dashboard_widget, user: @admin)
  end

  #----------------------------------------------------------------------------
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@widget).to be_valid
    end

    it 'must have user set' do
      @widget.user_id = nil
      expect(@widget).to_not be_valid
    end

    it 'must have settings' do
      @widget.settings = nil
      expect(@widget).to_not be_valid
    end

    describe 'type_id' do
      it 'must have type_id set' do
        @widget.type_id = nil
        expect(@widget).to_not be_valid
      end

      it 'must be included in the DASHBOARD_WIDGETS constant' do
        @widget.type_id = 0
        expect(@widget).to_not be_valid

        max_id = DASHBOARD_WIDGETS.keys.max

        @widget.type_id = max_id
        expect(@widget).to be_valid

        @widget.type_id = max_id + 1
        expect(@widget).to_not be_valid
      end
    end

    describe '#call_center_id' do
      it 'can be nil' do
        @widget.call_center_id = nil
        expect(@widget).to be_valid
      end

      it 'must belong to the same account' do
        other_call_center = FactoryGirl.create(:call_center)
        @widget.call_center = other_call_center
        expect(@widget).to_not be_valid
        expect(@widget.errors[:call_center_id]).to be_present

        @widget.call_center = @account.call_centers.first
        expect(@widget).to be_valid
      end
    end
  end

end
