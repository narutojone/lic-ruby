$(document).on('change', 'input.check-uncheck-column', function(e) {
  var $this = $(this);
  var $th = $this.closest('th');
  var $tr = $th.parent();
  var $table = $tr.closest('table');

  var colIndex = $tr.children().index($th);
  var checkAll = $this.attr('data-action') == 'check';

  var $table = $tr.closest('table');
  $table.find('td:nth-child(' + (colIndex + 1) + ')').each(function(index) {
    $(this).find('input[type="checkbox"]').prop('checked', checkAll);
  });

  $this.attr('data-action', checkAll ? 'uncheck' : 'check');
});
