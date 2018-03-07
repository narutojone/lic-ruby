function escapeHTML(string) {
 return $('<div/>').text(string).html();
}

function flash(text, title, color) {
  $.gritter.add({
    title: escapeHTML(title),
    text: escapeHTML(text),
    class_name: 'color ' + color,
    time: 2500
  });
}

function notice(text) {
  flash(text, 'Success', 'primary');
}

function alert(text) {
  flash(text, 'Error', 'danger');
}

function showErrorMessage() {
  alert('Something has gone wrong. Please contact support.');
}

$(document).ready(function () {
  $('.js-notification').each(function(index, element) {
    var $notification    = $(element);
    var notificationType = $notification.data('type');
    var notificationText = $notification.data('text');

    if (notificationType == 'notice') {
      notice(notificationText);
    }
    else {
      alert(notificationText);
    }
  });

  $('.js-notification').remove();
});

