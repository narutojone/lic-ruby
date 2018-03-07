require 'spec_helper'

describe 'PERMISSIONS constant hash' do
  it 'activity ids must be unique' do
    ids = []

    PERMISSIONS.each_value do |val|
      val[:activities].each_value do |id_and_label|
        expect(ids).not_to include(id_and_label[:id])
        ids << id_and_label[:id]
      end
    end
  end

  describe 'PERMISSIONS_LIST' do
    it 'returns array of permissions' do
      expect(PERMISSIONS_BY_ID[3]).to eq({group: 'role', activity: 'update'})
      expect(PERMISSIONS_BY_ID[38]).to eq({group: 'ticket', activity: 'close'})
    end
  end
end
