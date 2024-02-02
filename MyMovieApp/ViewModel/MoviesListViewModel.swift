//
//  MoviesListViewModel.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import Foundation

class MoviesListViewModel {
    var movies = Bindable<[Movie]>([])
    var currentPage = 1
    private var isFetching = false
    var hasMoreMovies = true
    var onErrorHandling: ((Error) -> Void)?
    var onAddToFavorites: ((Movie) -> Void)?

    private var networkManager: Networkable

    init(networkManager: Networkable) {
        self.networkManager = networkManager
    }

    func refreshMovies() {
        currentPage = 1
        hasMoreMovies = true
        movies.value.removeAll()
        fetchMovies()
    }

    func fetchMovies() {
        guard !isFetching, hasMoreMovies else { return }

        isFetching = true
        networkManager.fetchMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case let .success(newMovies):
                    let uniqueMovies = newMovies.filter { newMovie in
                        !self.movies.value.contains { existingMovie in
                            existingMovie.id == newMovie.id
                        }
                    }
                    self.movies.value.append(contentsOf: uniqueMovies)
                    if newMovies.isEmpty {
                        self.hasMoreMovies = false
                    } else {
                        self.currentPage += 1
                    }
                case let .failure(error):
                    self.onErrorHandling?(error)
                }
            }
        }
    }

    func triggerAddToFavorites(movie: Movie) {
        onAddToFavorites?(movie)
    }
}
