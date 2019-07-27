# Advanced shiny login example

This example combines a [simple shiny login](https://github.com/TimTeaFan/shiny-examples/tree/master/shiny-simple-login) approach with following additional features:

1. A login button that can be triggered by pressing 'enter'.
2. A user list with access rights, allowing to show different content depending on the corresponding user access rights.
3. A user login history counting the number of unsuccessful login attempts, blocking users with three or more login attempts.
4. A user log, recording username and timestamp of all successful login attempts.
[5](https://stackoverflow.com/questions/34142841/page-refresh-button-in-r-shiny). A 'fake' logout button which reloads the app and returns user to the 'login tab'.
6. A download handler that simultaneously saves all downloaded plots on server to keep track of what kind of plots users are downloading.

Some of the features are implementation adapted from answers StackOverflow. Click on the SO

You can find the app on [shinyapp.io](https://timteafan.shinyapps.io/shiny-adv-login/), given that I have still free hours of usage on my account.  

