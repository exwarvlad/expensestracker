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
//= require rails-ujs
//= require activestorage
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require date
//= require daterangepicker
//= require rails.validations
//= require_tree .

$(document).ready(function() {
    $('#search').on('keyup', function() {
        var value;
        value = $(this).val().toLowerCase();
        $('#search_list tr').filter(function() {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

$(function() {

    // duration_start and duration_end initializing in the expenses/index.html.erb
    var start = moment(duration_start);
    var end = moment(duration_end);
    var max_date = moment();

    function cb(start, end) {
        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }

    $('#reportrange').daterangepicker({
        startDate: start,
        endDate: end,
        maxDate: max_date,
        showDropdowns: true,
        ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        }
    }, cb);

    cb(start, end);

});


$(document).ready(function() {
    $('#data_amount_start').focusin(function() {
        $("label[for='data_amount_start']").attr('for', 'data_amount_finish')
    });

    $('#data_amount_finish').focusout(function () {
        $("label[for='data_amount_finish']").attr('for', 'data_amount_start')
    })
});
