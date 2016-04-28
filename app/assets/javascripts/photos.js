$(document).on('click','#flag_photo_button',function(){
    $('#flag_photo_button').removeClass('btn-success');
    $('#flag_photo_button').addClass('btn-danger');
    $('#flag_photo_button').val("Photo Flagged");
    //$('#flag_review_button').prop('disabled',true);
});

$(document).on('ajax:complete', function(){
  $('#flag_photo_button').prop('disabled',true);
});