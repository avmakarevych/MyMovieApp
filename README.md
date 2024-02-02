# MyMovieApp

MyMovieApp is an iOS application that provides a delightful way to browse and manage a collection of movies. It leverages the robust The Movie Database (TMDB) API to fetch movie details and presents them in an intuitive user interface. Users can explore a vast list of movies, mark their favorites, and view detailed information about each movie.

## Features

- **Movies List**: Browse a list of movies fetched from TMDB API. The movies are displayed in a list or grid view with the movie's poster, title, and release year.
- **Favorites**: Long-pressing on a movie in the Movies List adds it to the Favorites tab. Movies marked as favorites are accessible under the Favorites tab and are stored locally.
- **Movie Details**: Tapping on a movie displays detailed information about the movie, including the movie poster, a brief synopsis, and the release year.
- **Favorites Management**: In the Favorites tab, users can manage their favorite movies. They can view details of the movies and remove movies from their favorites.
- **Local Storage**: The app uses local storage (Core Data) to persistently store the user's favorite movies, avoiding duplicates.

## Technical Details

- **UI Framework**: UIKit
- **Layout**: Programmatic UI using Auto Layout and Constraints.
- **Architecture**: MVVM
- **Networking**: URLSession for API calls.
- **Data Parsing**: Codable protocol for model structuring.
- **Persistence**: Core Data for local storage of favorite movies.
- **API**: TMDB (The Movie Database)

## Getting Started

To run MyMovieApp, follow these steps:

1. **Clone the repository**:
    ```
    git clone https://github.com/avmakarevych/MyMovieApp.git
    ```

2. **Install Dependencies** (if the project uses CocoaPods/Carthage/Swift Package Manager):
    ```
    pod install
    // or
    carthage update
    // or
    swift package resolve
    ```

3. **Open the Project**:
    Open `MyMovieApp.xcworkspace` in Xcode.

4. **Set Up API Keys**:
    Replace the placeholders for API Key and Bearer Token in the respective constants file.

5. **Run the project**:
    Build and run the project in Xcode.
