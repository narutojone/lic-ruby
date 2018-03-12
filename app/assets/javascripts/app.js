//
//= require main
//= require app-ui-notifications
//= require app-charts
//

jQuery("input, textarea, select").blur();
jQuery(document).on("click", ".js-back-link", function(event) {
  var href = jQuery(this).attr("href");

  if (href == "#") {
    event.preventDefault();
    history.back();
  }
});
