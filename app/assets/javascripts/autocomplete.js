jQuery(document).ready(function($) {
    $('#search').autocomplete({
        minLength: 1,
        source: "/users.json",
        
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
        return $("<li></li>")
            .data("item.uiAutocomplete",item)
            .append("<a href='" + item.id + "'>" + "<div><img src='" + item.profile_pic.url + "'>  " + item.user_id + "</div></a>" )
            .appendTo(ul);
    }

});