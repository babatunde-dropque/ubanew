$.ajaxSetup({
    headers: {
     'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
});


function openRegisterModal(){
    $('#loginModal').modal('show');
     $('.error').removeClass('alert alert-danger').html('');
}

function submitAjax(){
  var email = $('#email').val()
    result = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
    if (!result){
        shakeModal(false, "Invalid email/ email can't be empty");
    } else if (!($('#name').val())) {
        shakeModal(false, "Name can't be empty ");
    } else if (!($('#organization').val())) {
        shakeModal(false, "Organization can't be empty");
    } else if (!($('#role').val())) {
        shakeModal(false, "Role can't be empty");
    } else {
      finalSubmit();
    }
}


function finalSubmit(){
  $('.error').removeClass('alert-danger').addClass('alert alert-success').html("Sending ...");
  $('#loading').addClass('fa fa-spinner fa-spin');
    var requestForm = $('#request-demo');
    $.ajax({
          url: '/landings/requestdemo',
          type: 'POST',
          data: requestForm.serialize(),
          success: function(data){
            if (data == "true"){
                shakeModal(true, "");
            } else if (data == "false"){
                shakeModal(false, "Couldn't complete your request, kindly try again");
            }
          },
          error : function(jqXHR, textStatus, errorThrown) {
             shakeModal(false, "Couldn't complete your request, kindly try again");
           }
       });
}

function shakeModal(option, content){
        $('#loading').removeClass('fa fa-spinner fa-spin');
        if (option){
            $('.error').removeClass('alert-danger').addClass('alert alert-success').html("We will get back to you shortly. Sent successfully <span class='glyphicon glyphicon-ok'>");
            $('#request-demo').trigger("reset");
        } else {
            $('#loginModal .modal-dialog').addClass('shake');
            $('.error').addClass('alert alert-danger').html(content);
            $('input[type="password"]').val('');
            setTimeout( function(){
                    $('#loginModal .modal-dialog').removeClass('shake');
            }, 1000 );
        }

}
