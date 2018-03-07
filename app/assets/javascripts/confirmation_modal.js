$(document).on('show.bs.modal', '#confirmation-modal', function (event) {
  var $button     = $(event.relatedTarget);
  var $modal      = $(this);
  var $formSubmit = $modal.find('.submit');

  var type    = $button.data('type');
  var message = $button.data('message');
  var method  = $button.data('form-method');
  var url     = $button.data('form-url');

  $modal.find('.i-circle').removeClass('text-danger text-warning').addClass('text-' + type);
  $modal.find('.confirmation-dialog-body').text(message);

  $formSubmit.removeClass('btn-danger btn-warning').addClass('btn-' + type);

  // remove actions and events from previous modal openings
  $formSubmit.off();
  $formSubmit.removeAttr('data-method');
  $formSubmit.removeAttr('href');

  if ($button.data('bulk')) {
    $formSubmit.click(function(event) {
      event.preventDefault();
      submitBulkIdsForm(url, method);
    });
  } else {
    $formSubmit.data('method', method);
    $formSubmit.attr('href', url);
  }
});
