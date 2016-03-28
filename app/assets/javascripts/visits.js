/*$(document).ready(function(){

    //hide errors div
    $('#errors').hide();

    //called when submitting a date form
    $('#date_form').on('submit', function(e){
        e.preventDefault();

        var flag = 0;
        //get value of start date box
        var start_date = document.getElementById("start_date").value;
        //get value of end date box
        var end_date = document.getElementById("end_date").value;

        document.getElementById("errors").innerHTML = "";

        //compare dates
        if (start_date > end_date) {
            document.getElementById("errors").innerHTML += "ERROR: Invalid dates";
            flag = 1;
        }

        if(flag == 0) {
            this.submit();
        } else {
            $('#errors').show();
        }
    });

});*/