/* WIDGET SELECTION MODAL */

function enableDisableWidgetAdding($widget_row, enable) {
  if (enable) {
    $widget_row.removeClass('active');
    $widget_row.find('.status-can-add').show();
    $widget_row.find('.status-can-not-add').hide();
  } else {
    $widget_row.addClass('active');
    $widget_row.find('.status-can-add').hide();
    $widget_row.find('.status-can-not-add').show();
  }
}

$(document).on('show.bs.modal', '#dashboard-widgets-modal', function(e) {
  var $modal = $(this);
  var $widgets_on_dashboard = $('.grid-stack .dashboard-widget');
  var widget_types_on_dashboard = [];

  // enable/disable adding widgets based on which ones are already on the dashboard
  $widgets_on_dashboard.each(function(index) {
    widget_types_on_dashboard.push($(this).data('widget-type'));
  });
  $modal.find('.dashboard-widgets-list li').each(function(index) {
    var $li = $(this);
    enableDisableWidgetAdding($li, $li.data('multiple') || widget_types_on_dashboard.indexOf($li.data('type-id')) === -1);
  });
});

function showHideWidgetsOnWidgetSelectModal($link, condition) {
  var value = $link.data(condition);
  if (value) {
    $('.dashboard-widgets-list li').each(function(index) {
      var $li = $(this);
      if ($li.data(condition) === value) {
        $li.show();
      } else {
        $li.hide();
      }
    });
  } else {
    $('.dashboard-widgets-list li').show();
  }
}

$(document).on('click', '.dashboard-widget-category-select-link', function(e) {
  e.preventDefault();
  showHideWidgetsOnWidgetSelectModal($(this), 'category');
});

$(document).on('click', '.dashboard-widget-kind-select-link', function(e) {
  e.preventDefault();
  showHideWidgetsOnWidgetSelectModal($(this), 'kind');
});

$(document).on('change', '.grid-stack', function(event, items) {
  var updated_widgets = {};
  for (var i = 0; i < items.length; i++) {
    var widget = items[i].el.find('.dashboard-widget');
    var stack_item = widget.parent();
    // Let's see if cordinates actually changed
    // (this change event reports changes even when nothing changed)
    if (stack_item.data('gs-x') != items[i].x || stack_item.data('gs-y') != items[i].y) {
      updated_widgets[widget.data('widget-id')] = {
        'x': items[i].x,
        'y': items[i].y
      }
    }
  }

  if (Object.keys(updated_widgets).length > 0) {
    $.post('/dashboard_widgets/update_positions', {
      '_method': 'patch',
      'updated_widgets': updated_widgets
    });
  }
});

/* WIDGET SETTINGS */

// Replace previous contents of the modal with a blank loading state
$(document).on('show.bs.modal', '#widget-settings-modal', function (e) {
  $(this).find('.modal-content').html($('#widget-settings-modal-blank-slate-template').html());
});

$(document).on('shown.bs.modal', '#widget-settings-modal', function (e) {
  var $widget  = $(e.relatedTarget).closest('.dashboard-widget');
  var $modal   = $(this);
  var widgetId = $widget.data('widget-id');

  $.get('/dashboard_widgets/' + widgetId + '/edit', function(data) {
    $modal.find('.modal-body').remove();
    $modal.find('.modal-footer').remove();
    $modal.find('.modal-content').append(data);
  }).fail(function() {
    $modal.find('.modal-body').html('<span class="text-danger">Form loading failed.</span>');
  });
});

//-----------------------------------------------------------------------------
function setWidgetStateToLoading(widget_id) {
  $('.dashboard-widget[data-widget-id="' + widget_id + '"] .widget-contents').removeClass('widget-contents').addClass('loading').html('<i class="fa fa-spinner fa-spin fa-2x text-primary"></i>');
}

function loadWidgetContents($widget_box) {
  var $content = $widget_box.find('.loading');
  var url = '/dashboard_widgets/' + $widget_box.attr('data-widget-id');

  $.get(url, function(data) {
    $content.html(data).removeClass('loading').addClass('widget-contents');

    var $widgetNumber = $content.find('.widget-number');
    var $number       = $widgetNumber.find('.value');
    var $desc         = $widgetNumber.find('.desc');
    var numberCount   = $number.text();
    var descLength    = $desc.text().length;

    if (numberCount >= 1000 && numberCount < 10000){
      $number.addClass('value-sm');
    }
    else if (numberCount >= 10000){
      $number.addClass('value-xs');
    }
    if (descLength >= 15 && descLength < 30){
      $desc.addClass('desc-sm');
    }
    else if (descLength >= 30){
      $desc.addClass('desc-xs');
    }

    var height_in_rows = Math.ceil($content.height() / (120 + 30));
    var gridStack = $('.grid-stack').data('gridstack');
    if (gridStack) { // we may have already navigated away from dashboard
      gridStack.resize($widget_box.parent(), null, height_in_rows);
    }
  }).fail(function(jqXHR, textStatus, errorThrown) {
    var msg = 'Loading failed.';

    if (jqXHR.status === 401)
      msg += " You don't have the necessary permissions to see this widget.";

    $content.html('<span class="text-danger">' + msg + '</span>');
  });
}

function initGridStack() {
  var gridStack = $('.grid-stack').gridstack({
    cellHeight: 125,
    disableResize: true
  });
}

//-----------------------------------------------------------------------------
$(document).ready(function () {
  initGridStack();

  $('.dashboard-widget').each(function(index, element) {
    loadWidgetContents($(element));
  });
});
