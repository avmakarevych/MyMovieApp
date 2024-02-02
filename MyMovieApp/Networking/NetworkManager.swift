//
//  NetworkManager.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import Foundation

class NetworkManager: Networkable {
    private let session = URLSession(configuration: .default)

    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(API.baseURL)movie/popular?language=en-US&page=\(page)&api_key=\(API.apiKey)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(API.authToken, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, _, error in

            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let moviesResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(moviesResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let url = URL(string: "\(API.baseURL)genre/movie/list?language=en-US&api_key=\(API.apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let genresResponse = try JSONDecoder().decode(GenreResponse.self, from: data)
                completion(.success(genresResponse.genres))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
