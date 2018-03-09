var App = (function () {
  'use strict';
  
  App.charts = function( ){

    // colors of the pie widgets
    var color1 = App.color.primary;
    var color2 = tinycolor( App.color.primary ).lighten( 5 ).toString();
    var color3 = tinycolor( App.color.primary ).lighten( 10 ).toString();
    var color4 = tinycolor( App.color.primary ).lighten( 15 ).toString();
    var color5 = tinycolor( App.color.primary ).lighten( 20 ).toString();
    var color6 = tinycolor( App.color.primary ).lighten( 25 ).toString();
    var color7 = tinycolor( App.color.primary ).lighten( 30 ).toString();
    var color8 = tinycolor( App.color.primary ).lighten( 35 ).toString();
    var color9 = tinycolor( App.color.primary ).lighten( 40 ).toString();
    var color10 = tinycolor( App.color.primary ).lighten( 45 ).toString();
    var color11 = tinycolor( App.color.alt4 ).lighten( 5 ).toString();
    var color12 = tinycolor( App.color.alt4 ).lighten( 10 ).toString();
    var color13 = tinycolor( App.color.alt4 ).lighten( 15 ).toString();
    var color14 = tinycolor( App.color.alt3 ).lighten( 5 ).toString();
    var color15 = tinycolor( App.color.alt3 ).lighten( 10 ).toString();
    var color16 = App.color.alt1; // 
    var color17 = App.color.alt2; // yelloy
    var color18 = App.color.alt3; // 
    var color19 = App.color.alt4; // gray
    var color20 = App.color.alt5;

    //Top pie widget 1
    function widget_top_1(){
      
      var data = [
        { label: "Active (23)", data: 65 },
        { label: "Inactive (6)", data: 38 },
        { label: "Trial (5)", data: 27 }
      ];

      var color1 = App.color.primary;
      var color2 = App.color.danger;
      var color3 = App.color.warning;

      var legendContainer = $("#widget-top-1").parent().next().find(".legend");

      $.plot('#widget-top-1', data, {
        series: {
          pie: {
            show: true,
            innerRadius: 0.5,
            highlight: {
              opacity: 0.3
            },
            stroke:{
              width: 0
            }
          }
        },
        grid:{
          hoverable: true
        },
        legend:{
          container: legendContainer
        },
        colors: [color1, color2, color3]
      });
    }

    // widget
    widget_top_1();

  };

  return App;
})(App || {});
