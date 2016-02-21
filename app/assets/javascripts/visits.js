$(document).ready(function(){

    $('#errors').hide();

    $('#date_form').on('submit', function(e){
        e.preventDefault();

        var flag = 0;
      //val not returning value, but a bunch of javascript
        var start_date = $('#start_date').val;
        var end_date = $('#end_date').val;

        document.getElementById("errors").innerHTML = "";


        if (start_date > end_date) {
          alert("flag");
            document.getElementById("errors").innerHTML += "ERROR: Invalid dates";
            flag = 1;
        }

        if(flag == 0) {
            this.submit();
        } else {
            $('#errors').show();
        }
    });

});