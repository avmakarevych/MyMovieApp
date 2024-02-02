//
//  MovieEntity+CoreDataProperties.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 02.02.2024.
//
//

import CoreData
import Foundation

public extension MovieEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged var id: Int64
    @NSManaged var title: String?
    @NSManaged var overview: String?
    @NSManaged var releaseDate: String?
    @NSManaged var posterPath: String?
    @NSManaged var backdropPath: String?
    @NSManaged var genreIDs: Data?
    @NSManaged var popularity: Double
    @NSManaged var voteAverage: Double
}

extension MovieEntity: Identifiable {}
