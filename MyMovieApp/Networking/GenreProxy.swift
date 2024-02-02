//
//  GenreProxy.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 02.02.2024.
//

import Foundation

class GenreProxy {
    private var genres: [Int: String] = [:]
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func fetchGenres(completion: @escaping () -> Void) {
        networkManager.fetchGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(genresArray):
                    self?.genres = genresArray.reduce(into: [Int: String]()) { dict, genre in
                        dict[genre.id] = genre.name
                    }
                    completion()
                case let .failure(error):
                    print("Error fetching genres: \(error)")
                    completion()
                }
            }
        }
    }

    func genreNames(fromIds ids: [Int]) -> String {
        return ids.compactMap { genres[$0] }.joined(separator: ", ")
    }
}
