# Advanced shiny login example

This example combines the [simple shiny login](http://link) approach with following additional features:

1. A login button that can be triggered by pressing 'enter'.
2. A user list with access rights, allowing to show different content depending on the corresponding user access rights.
3. A user login history counting the number of unsuccessful login attempts, blocking users with three or more login attempts.
4. A user log, recording username and timestamp of all successful login attempts.
5. A 'fake' logout button which reloads the app and returns user to the 'login tab'.
6. A download handler that simultaneously saves all downloaded plots on server to keep track of what kind of plots users are creating.

