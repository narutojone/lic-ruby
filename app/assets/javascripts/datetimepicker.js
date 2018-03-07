function buildDatePicker($container) {
  var $input      = $container.find('input[type="text"]');
  var $valueField = $container.find('.js-date-value');

  if (typeof $input.datetimepicker === 'function') {
    if ($valueField.length === 0) {
      $valueField = $('<input/>', {
        type:  'hidden',
        name:  $input.attr('name'),
        value: $input.attr('value'),
        class: 'js-date-value ' + $input.attr('class')
      });

      $container.append($valueField);
    }

    $input.removeAttr('name');
    $input.removeClass('value');

    if ($input.val() !== undefined && /\-/.test($input.val())) {
      $input.val(moment($input.val(), 'YYYY-MM-DD').format('MM/DD/YYYY'));
      $valueField.val(moment($input.val(), 'MM/DD/YYYY').format('YYYY-MM-DD'));
    }

    $container.datetimepicker({
      format: 'mm/dd/yyyy',
      autoclose: true,
      minView: 2,
      componentIcon: '.s7-date',
      navIcons:{rightIcon: 's7-angle-right', leftIcon: 's7-angle-left'}
    });

    $container.on('hide', function(event) {
      var selectedValue = $input.val();

      if (selectedValue !== '') {
        $valueField.val(moment(selectedValue, 'MM/DD/YYYY').format('YYYY-MM-DD'));
      }
      else {
        $valueField.val('');
      }
    });
  }
}

$(document).ready(function () {
  $('.input-group.date').each(function() {
    buildDatePicker($(this));
  });
});
