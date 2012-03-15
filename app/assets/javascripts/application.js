// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require googleanalytics
//= require jquery
//= require jquery_ujs
//= require vendor/jquery.ui
//= require vendor/range_slider
//= require vendor/date_range_slider
//= require vendor/underscore
//= require vendor/backbone
//= require vendor/handlebars
//= require vendor/modal
//= require vendor/tabs
//= require vendor/twipsy
//= require vendor/popover
//= require vendor/tablesorter
//= require vendor/default.input

// The uploaders should only be serve for admins, not the regular users
//= require vendor/plupload.full

//= require map
//= require activity
//= require category
//= require region
//= require target
//= require searcher
//= require uploader
//= require app


/*
 *
 * ACTIVITY FORM
 *
*/

var monthNames = ['Januar','Februar','Mars','April','Mai','Juni','Juli','August','September','Oktober','November','Desember'];
var dayNamesMin = ['Sø', 'Ma', 'Ti', 'On', 'To', 'Fr', 'Lø'];

function updateStartAndEndTime(){
  var start_time = $("#dtstart_date").val() + 'T' +  $("#dtstart_time").val();
  var end_time = $("#dtend_date").val() + 'T' + $("#dtend_time").val();
  $("#activity_dtstart").val(start_time);
  $("#activity_dtend").val(end_time)
}

$(document).ready(function(){


  $("#dtstart_time, #dtend_time, .date").keyup(function(){updateStartAndEndTime()});

  $(".date").datepicker({
    dateFormat: 'dd.mm.yy',
    dayNamesMin: dayNamesMin,
    monthNames: monthNames,
    onSelect: function(dateText, inst) {updateStartAndEndTime()}
  });

  //allow helper text in fields. Set the :title tag to use it
  $.defaultText();

  //auto select veichle from list
  $("#choose_veichle").change(function(e){
     $("#activity_vehicle").val($(e.currentTarget).val())
  });

  //help popover
  $('a[rel=popover]').popover({placement:'right', html:true});
  $('a[rel=popover]').click(function(e){e.preventDefault();return false;})


});