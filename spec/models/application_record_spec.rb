require 'spec_helper'

# Note and Ticket were removed
# describe ApplicationRecord do
#   before do
#     @account = FactoryBot.create(:account)
#     @admin   = account_admin(@account)
#     # @ticket  = FactoryBot.create(:ticket, account: @account)
#     # @note    = FactoryBot.build(:note, ticket: @ticket)
#   end
#
#   #----------------------------------------------------------------------------
#   describe '.html_string' do
#     it 'defines method that overrides default attribute writer with sanitizer' do
#       @note.text = '<p><a href="http://google.com">Google</a>Test 123<script></script></p>'
#       expect(@note.text).to eq('<p><a href="http://google.com">Google</a>Test 123</p>')
#     end
#
#     it 'writes empty string if there is no meaningful content inside' do
#       @note.text = '<p><span></span><br></p>'
#       expect(@note.text).to be_blank
#     end
#   end
#
#   #----------------------------------------------------------------------------
#   describe '#set_current_user' do
#     before do
#       @note = Note.new
#     end
#
#     it 'sets Thread[:current_user]' do
#       Thread.current[:current_user] = @admin
#       @note.send(:set_current_user)
#
#       expect(@note.user).to eq(@admin)
#     end
#   end
# end
