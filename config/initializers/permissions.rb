PERMISSIONS = {
  'role' => {
    label: 'Roles',
    activities: {
      'index' => {id: 1, label: 'List'},
      'create' => {id: 2, label: 'Create'},
      'update' => {id: 3, label: 'Update'},
      'destroy' => {id: 4, label: 'Delete'}
    }
  },

  'user' => {
    label: 'Users',
    activities: {
      'index' => {id: 5, label: 'List'},
      'show' => {id: 6, label: 'Show details'},
      'show_location' => {id: 40, label: 'Show Location'},
      'create' => {id: 7, label: 'Create'},
      'update' => {id: 8, label: 'Update'},
      'destroy' => {id: 9, label: 'Delete'}
    }
  },

  'email_notification' => {
    label: 'Email notifications',
    activities: {
      'index' => {id: 34, label: 'List'},
      'update' => {id: 35, label: 'Update'},
    }
  }
}

#------------------------------------------------------------------------------
# PERMISSIONS_BY_ID: hash of {1 => {group: 'role', activity: 'index'}, 2 => {group: 'role', activity: 'edit'}}
PERMISSIONS_BY_ID = {}
PERMISSIONS.each do |permission_group_name, permission_group|
  permission_group[:activities].each do |activity_name, activity_id_label|
    PERMISSIONS_BY_ID[activity_id_label[:id]] = {group: permission_group_name, activity: activity_name}
  end
end
