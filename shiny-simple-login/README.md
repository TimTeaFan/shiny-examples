# Simple shiny login without using shiny server

A common question among shiny users is, how to create a login page without relying on shiny server pro. There are different implementations achieving this, some of them can be found on StackOverflow. I have created an approach which tries to keep things as simple as possible relying on `shinjs` and `appendTab` `removeTab`.

It might help those, who do not want to work with two separate UI functions.

The approach builds on two steps:

1. Create a login tab where users can log in. All other tabs are not displayed yet, neither is the sidebar.
2. When login is successful: Append the tabs you actually want to show, remove the login tab (it's no longer needed) and show sidebar with `shinyjs`.

You can find the app on [shinyapp.io](https://timteafan.shinyapps.io/shiny-simple-login/), given that I have still free hours of usage on my account.  

This approach can be expanded by adding several features, which I show in a separate example.

