# Fakeflix: A Flutter Movie Streaming App

This is a simple Flutter-based movie streaming app called Fakeflix. The app mimics a Netflix-like interface and allows users to explore movies, search for specific titles, and view detailed information about each movie. The app fetches data from the TVMaze API to display movie information.

# Features
1. Splash Screen
   The splash screen displays a logo or an appropriate image related to the app, showing briefly before navigating to the Home Screen.

2. Home Screen
   The home screen shows a grid of movie thumbnails, titles, and summaries. It fetches data from the TVMaze API endpoint:
   https://api.tvmaze.com/search/shows?q=all
   Clicking on any movie item redirects the user to the Details Screen.

3. Search Screen
   The search screen has a search bar that allows the user to type a movie title. It fetches and displays results from the TVMaze API:
   https://api.tvmaze.com/search/shows?q={search_term}
   The search results are displayed in a similar format to the Home Screen.

4. Details Screen
   When a movie is clicked on the Home Screen or Search Screen, the app navigates to the Details Screen where more information about the movie is displayed.

5. Bottom Navigation: Provides navigation between the Home Screen and Search Screen.

# Screenshots
Splash Screen
![Splash screen](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/splash.jpeg)
Home Screen
![Home screen](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/home.jpeg)
Search Screen
![search screen 1](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/search1.jpeg)
![search screen 2](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/search2.jpeg)
Details Screen
![details screen 1](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/details1.jpeg)
![details screen 2](https://github.com/TheImperialOne/fakeflix/blob/master/screenshots/details2.jpeg)

# Working

Contributing
Feel free to fork this project and submit pull requests. If you find any bugs or have feature requests, please open an issue.

License
This project is licensed under the MIT License - see the LICENSE file for details.