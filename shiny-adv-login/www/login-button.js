$(document).keyup(function(event) {
    if ( ($("#username").is(":focus") && (event.key == "Enter")) ||
         ($("#password").is(":focus") && (event.key == "Enter")) ) {
        $("#login").click();
    }
});