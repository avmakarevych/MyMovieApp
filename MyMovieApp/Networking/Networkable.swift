//
//  Networkable.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

protocol Networkable {
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}
