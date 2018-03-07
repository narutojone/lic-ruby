# == Schema Information
#
# Table name: dashboard_widgets
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  type_id    :integer          not null
#  settings   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

RSpec.describe DashboardWidgetsController do

  before do
    create_account_and_login
    @admin = account_admin(@account)
    @call_center = @account.call_centers.first
    @admin.call_centers << @call_center
  end

  #----------------------------------------------------------------------------
  describe '#dashboard' do
    it 'loads user widgets ordered by position' do
      w1 = FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 1, y: 1})
      w2 = FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 0, y: 1})
      w3 = FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 1, y: 2})
      get :dashboard
      expect(assigns(:widgets)).to eq([w2, w1, w3])
    end
  end

  #----------------------------------------------------------------------------
  describe '#show' do
    before do
      @widget = FactoryGirl.create(:dashboard_widget, user: @admin)
    end

    it 'gathers data based on the widget' do
      get :show, params: {id: @widget.id}
      expect(assigns(:data)).to eq({number_of_users: 1, account_limit: 3})
    end

    it 'renders widgets partial when user is authorized to see that widget' do
      @widget.update_column(:type_id, 2)
      expect(controller).to receive(:policy).and_return(double(index?: true))
      get :show, params: {id: @widget.id}
      expect(response).to render_template('dashboard_widgets/widgets/_user_roles_pie_chart')
      expect(response).to have_http_status(200)
    end

    it 'renders unconfigured widget partial when the widget data is nil' do
      expect(controller).to receive(:policy).and_return(double(index?: true))
      expect_any_instance_of(DashboardWidgetDataGatherer).to receive(:data).and_return(nil)
      get :show, params: {id: @widget.id}
      expect(response).to render_template('dashboard_widgets/_unconfigured_widget')
      expect(response).to have_http_status(200)
    end

    it 'renders HEAD unauthorized when the user is not authorized to see that widget' do
      expect(controller).to receive(:policy).and_return(double(index?: false))
      get :show, params: {id: @widget.id}
      expect(response).to have_http_status(401)
    end
  end

  #----------------------------------------------------------------------------
  describe '#create' do
    it 'creates the widget' do
      expect {
        post :create, params: {dashboard_widget: {type_id: 2}, format: :js}
      }.to change { @admin.dashboard_widgets.count }.by(1)
      widget = @admin.dashboard_widgets.order(:id).last
      expect(widget.type_id).to eq(2)
    end

    it 'sets the position as the last widget' do
      FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 0, y: 2})
      post :create, params: {dashboard_widget: {type_id: 2}, format: :js}
      widget = @admin.dashboard_widgets.order(:id).last
      expect(widget.settings).to eq({'x' => 0, 'y' => 3})
    end

    it 'sets call center if the user belongs to only one call center' do
      post :create, params: {dashboard_widget: {type_id: 2}, format: :js}
      widget = @admin.dashboard_widgets.order(:id).last
      expect(widget.call_center).to eq(@call_center)
    end

    it 'does not set call center if the user belongs to multiple call centers' do
      call_center2 = FactoryGirl.create(:call_center, account: @account)
      @admin.call_centers << call_center2

      post :create, params: {dashboard_widget: {type_id: 2}, format: :js}
      widget = @admin.dashboard_widgets.order(:id).last
      expect(widget.call_center).to be_nil
    end

    it 'returns 201 created' do
      post :create, params: {dashboard_widget: {type_id: 2}, format: :js}
      expect(response).to have_http_status(:created)
    end
  end

  #----------------------------------------------------------------------------
  describe '#update_positions' do
    before do
      @w1 = FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 0, y: 0})
      @w2 = FactoryGirl.create(:dashboard_widget, user: @admin, settings: {x: 1, y: 0})
    end

    it 'updates widget positions' do
      patch :update_positions, params: {updated_widgets: {@w1.id => {x: 1, y: 0}, @w2.id => {x: 0, y: 0}}}
      expect(@w1.reload.settings).to eq({'x' => 1, 'y' => 0})
      expect(@w2.reload.settings).to eq({'x' => 0, 'y' => 0})
    end

    it 'converts position strings to integers' do
      patch :update_positions, params: {updated_widgets: {@w1.id => {'x' => '1', 'y' => '0'}}}
      expect(@w1.reload.settings).to eq({'x' => 1, 'y' => 0})
    end

    it 'returns with HEAD ok' do
      patch :update_positions, params: {updated_widgets: {@w1.id => {x: 1, y: 0}}}
      expect(response).to have_http_status(:ok)
    end
  end

  #----------------------------------------------------------------------------
  describe '#update' do
    before do
      @w = FactoryGirl.create(:dashboard_widget, user: @admin, call_center: @call_center, settings: {period: 'last_week', x: 2, y: 1})
      @call_center2 = FactoryGirl.create(:call_center, account: @account)
    end

    it 'updates params and widget settings via merge' do
      patch :update, params: {id: @w.id, dashboard_widget: {call_center_id: @call_center2.id, settings: {period: 'this_week'}}, format: :js}
      expect(@w.reload.call_center_id).to eq(@call_center2.id)
      expect(@w.settings).to eq({'period' => 'this_week', 'x' => 2, 'y' => 1})
    end

    it 'updates params if settings do not change' do
      patch :update, params: {id: @w.id, dashboard_widget: {call_center_id: @call_center2.id}, format: :js}
      expect(@w.reload.call_center_id).to eq(@call_center2.id)
      expect(@w.settings).to eq({'period' => 'last_week', 'x' => 2, 'y' => 1})
    end

    it 'updates widget settings via merge if other columns do not change' do
      patch :update, params: {id: @w.id, dashboard_widget: {settings: {period: 'this_week'}}, format: :js}
      expect(@w.reload.call_center_id).to eq(@call_center.id)
      expect(@w.settings).to eq({'period' => 'this_week', 'x' => 2, 'y' => 1})
    end
  end

  #----------------------------------------------------------------------------
  describe '#destroy' do
    it 'deletes the widget' do
      w = FactoryGirl.create(:dashboard_widget, user: @admin)
      expect {
        delete :destroy, params: {id: w.id, format: :js}
      }.to change { @admin.dashboard_widgets.count }.by(-1)
    end
  end

end
