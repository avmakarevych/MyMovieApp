//
//  Movie.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let genreIDs: [Int]
    let popularity: Double
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
    }

    init(entity: MovieEntity) {
        id = Int(entity.id)
        title = entity.title ?? ""
        overview = entity.overview ?? ""
        releaseDate = entity.releaseDate ?? ""
        posterPath = entity.posterPath
        backdropPath = entity.backdropPath
        popularity = entity.popularity
        voteAverage = entity.voteAverage

        if let genreData = entity.genreIDs,
           let genreIDs = try? JSONDecoder().decode([Int].self, from: genreData)
        {
            self.genreIDs = genreIDs
        } else {
            genreIDs = []
        }
    }
}
