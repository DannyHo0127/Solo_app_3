I used an advice api (https://api.adviceslip.com/advice) that will return random life advice using http.get.
When calling get on advice api, it will return a slip object with ID(int) and advice(string)

To run this script, just run the main.dart folder using the play button on the top screen in android studio

The user action is a button that will refresh the advice api and return a new random advice.

One edge case for this app is that if the user is offline and tries to get a new advice, 
the script will catch the error and inform user had bad connection.
