o # Advanced shiny login example

This example combines a [simple shiny login](https://github.com/TimTeaFan/shiny-examples/tree/master/shiny-simple-login) approach with following additional features:

1. A login button that can be triggered by pressing 'enter'.
2. A user list with access rights allowing to show different content depending on the corresponding access rights.
3. A user login history counting the number of unsuccessful login attempts, blocking users with three or more login attempts.
4. A message-handler sending custom messages in case of wrong or blocked username or when password is wrong.
5. A user log recording username and timestamp of all successful login attempts.
6. A 'fake' logout tab which reloads the app and returns users to the 'login tab'.
7. A download handler that simultaneously saves all downloaded plots on server to keep track of what kind of plots which user downloaded.

Some of the features ([1.](https://stackoverflow.com/questions/32335951/using-enter-key-with-action-button-in-r-shiny) and [6.](https://stackoverflow.com/questions/34142841/page-refresh-button-in-r-shiny)) are implementations adapted from answers on StackOverflow. Follow the link to learn more.

You can find the app on [shinyapp.io](https://timteafan.shinyapps.io/shiny-adv-login/), given that I have still free hours of usage on my account.  

