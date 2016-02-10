$(document).ready(function(){
    $('#errors').hide();
    
    $('#signup_form').on('submit', function(e){
        e.preventDefault();
        
        var flag = 0;
        var pass = $('#signup_pass').val();
        var pass_conf = $('#signup_pass_conf').val();
        
        document.getElementById("errors").innerHTML = ""
        
        if($('#signup_id').val() === "") {
            document.getElementById("errors").innerHTML += "ERROR: You must have a user id! </br>"
            flag = 1;
        }
        
        if (pass != pass_conf) {
            document.getElementById("errors").innerHTML += "ERROR: Passwords do not match </br>"
            flag = 1;
        }
        if (pass.length < 6 || pass.length > 12) {
            document.getElementById("errors").innerHTML += "ERROR: Password is of invalid length (Must be between 6 and 12 characters) </br>"
            flag = 1;
        }

        var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        if(!re.test($('#signup_email').val())) {
            document.getElementById("errors").innerHTML += "ERROR: Invalid Email Address </br>"
            flag = 1;
        }

        if(flag == 0) {
            this.submit();
        } else {
            $('#errors').show();
        }
    });
    
});