// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/jquery-3.2.1.min
//= require jquery_ujs
//= require jquery-ui/jquery-ui.min
//= require lodash/lodash
//= require jquery.nanoscroller/javascripts/jquery.nanoscroller.min
//= require jquery.gritter/js/jquery.gritter.min
//= require jquery-flot/jquery.flot
//= require jquery-flot/jquery.flot.pie
//= require jquery-flot/jquery.flot.resize
//= require jquery-flot/plugins/jquery.flot.orderBars
//= require jquery-flot/plugins/curvedLines
//= require chartjs/Chart.min
//= require pace/pace.min
//= require spectrum/spectrum
//= require summernote/summernote.min
//= require summernote/summernote-ext-amaretti
//= require select2/select2.min
//= require bootstrap-multiselect/bootstrap-multiselect
//= require datetimepicker/js/bootstrap-datetimepicker.min
//= require gridstack/gridstack
//= require gridstack/gridstack.jQueryUI.min
//= require functions
//= require bootstrap/dist/js/bootstrap.min

jQuery(document).on("blur", "input, textarea, select", function(event) {
  var value = jQuery(this).val();

  if (value) {
    jQuery(this).addClass("edited");
  } else {
    jQuery(this).removeClass("edited");
  }
});
