$(document).ready(function(){

	// gridstack
	$('.grid-stack').gridstack({
		disableResize: true
	});

	// tooltips
	$('[data-tooltip]').tooltip({ 'trigger': 'hover' });

	// spectrum color
	$('.spectrum').spectrum();
	$('.spectrum-ticket-types').spectrum({
		showPaletteOnly: true,
	    showPalette:true,
	    palette: [
	        ['#8A8A8A', '#676767', '#907ED1', '#7C6DB5', '#EB984E', '#DC7633', '#B7D162'],
	        ['#A5C04D', '#AAB7B8', '#99A3A4', '#AF7AC5', '#A569BD', '#FFD735', '#FFB933'],
	        ['#B59E8D', '#A58E7E', '#7384B4', '#61709A', '#5DADE2', '#5499C7', '#69D167'],
	        ['#40C03E', '#D5C295', '#BDC3C7', '#B8C9F1', '#99ABD5', '#EC7063', '#CD6155'],
	        ['#58D68D', '#52BE80', '#F28D95', '#E1767A', '#48C9B0', '#45B39D', '#25A0DA'],
	    ]
	});

	//Summernote
	$('.summernote').summernote({
		height: 200
	});
	$('.summernote-min').summernote({
		height: 200,
		toolbar: [
		  // [groupName, [list of button]]
		  ['style', ['bold', 'italic', 'underline', 'clear']],
		  ['fontsize', ['fontsize']]
		]
	});

	// select2
	$(".select2").select2({
	  theme: "default",
	  width: '100%',
	  allowClear: true,
	  placeholder: 'placeholder'
	});

	// select2 multiple
	$(".select2-multiple").select2({
	  theme: "default",
	  width: '100%',
	  allowClear: true,
	  placeholder: 'placeholder'
	});

	// multiple select
    $('.form-control-multiple').multiselect({
        //nonSelectedText: $(this).attr('sss'),
        //enableFiltering: true,
        maxHeight: 300,
        onChange: function(options, checked) {
          var $option = $(options);
          if ($option.length == 1) {
              var $group = $option.parent('optgroup')
          }
        }
    });

    // datetimepicker
    $(".datetimepicker").datetimepicker({
      autoclose: true,
      componentIcon: '.s7-date',
      navIcons:{
        rightIcon: 's7-angle-right',
        leftIcon: 's7-angle-left'
      }
    });

	// email placeholders
	$('#show-placeholders-button').click(function(){
		$(this).siblings('#placeholder-list').slideToggle();
		return false;
	});

	// dashboard settings block
	$(".btn-settings").click(function (){
		$(".content-block-settings").slideToggle();
	});

	// advanced search
	$('.btn-adv-search').click(function(){
		$(this).addClass('disabled');
		$(".adv-search-block").toggleClass('adv-search-block-visible');
		$(".main-content").prepend("<div class='overlay'></div>");
		return false;
	});
	$('.adv-search-block .btn-delete').click(function(){
		$(".adv-search-block").toggleClass('adv-search-block-visible');
		$(".overlay").remove();
		$('.btn-adv-search').removeClass('disabled');
		return false;
	});

	// dashboard widgets number size
	/*$('.widget-number').each(function(index){
	  var number = $(this).find('.value').text();
	  var desc = $(this).find('.desc').text().length;
	  //console.log(desc);
	  if (number >= 1000 && number < 10000){
	  	$(this).find('.value').addClass('value-sm');
	  }
	  else if (number >= 10000){
	  	$(this).find('.value').addClass('value-xs');
	  }
	  if (desc >= 15 && desc < 30){
	  	$(this).find('.desc').addClass('desc-sm');
	  }
	  else if (desc >= 30){
	  	$(this).find('.desc').addClass('desc-xs');
	  }
	});*/

	// customer edit radio select
	if ($('input[id="st-1"]').is(":checked")){
		$('input[id="st-1"]').parents('.form-group').siblings('.trial-block').slideUp();
	}
	if ($('input[id="st-2"]').is(":checked")){
		$('input[id="st-2"]').parents('.form-group').siblings('.trial-block').slideUp();
	}
	if ($('input[id="st-3"]').is(":checked")){
		$('input[id="st-3"]').parents('.form-group').siblings('.trial-block').slideDown();
	}
	$('input[name="st"]').change(function(){
		var st = $(this).attr('id');
		if (st == 'st-1'){
			$('.trial-block').slideUp();
		}
		else if (st == 'st-2'){
			$('.trial-block').slideUp();
		}
		else if (st == 'st-3'){
			$('.trial-block').slideDown();
		}
		
	});

});
    

