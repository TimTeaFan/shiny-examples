// This script will make login button accept enter as click
$(document).keyup(function(event) {
    if ( ($("#username").is(":focus") && (event.key == "Enter")) ||
         ($("#password").is(":focus") && (event.key == "Enter")) ) {
        $("#login").click();
    }
});