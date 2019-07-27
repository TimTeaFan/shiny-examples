// This recieves messages of type "loginmessage" from the server.
Shiny.addCustomMessageHandler("loginmessage",
                               function(message) {
                                   alert(JSON.stringify(message));
                               }
);