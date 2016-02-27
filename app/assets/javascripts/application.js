// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require homepage.js
//= require jquery-ui
//= require autocomplete-rails
//= require_tree .
//= require bootstrap-sprockets
$('.dropdown-toggle').dropdown()

jQuery(document).ready(function($) {
    $('#search').autocomplete({
        minLength: 1,
        source: "<%= autocomplete_user_user_id_users_path(:json) %>",
        
        focus: function(event, ui){
            $('#search').val(ui.item.user_id);
            return false;
        },
        select: function(event, ui){
            $('#search').val(ui.item.user_id);
            return false;
        }
    })
    
    .data("uiAutocomplete")._renderItem = function(ul,item){
        alert(item.id);
        return $("<li></li>")
            .data("item.uiAutocomplete",item)
            .append("<img src='" + item.profile_pic + "'>")
            .append("<a>" + item.user_id + "<br>" + item.first_name + " " + item.last_name + "</a>" )
            .appendTo(ul);
    }

});