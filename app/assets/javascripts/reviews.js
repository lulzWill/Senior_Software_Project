$(document).on('click','#flag_review_button',function(){
    $('#flag_review_button').removeClass('btn-success');
    $('#flag_review_button').addClass('btn-danger');
    $('#flag_review_button').val("Review Flagged");
    //$('#flag_review_button').prop('disabled',true);
});

$(document).on('ajax:complete', function(){
  $('#flag_review_button').prop('disabled',true);
});