//
//  FavoritesViewModel.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import CoreData
import Foundation

class FavoritesViewModel {
    var favorites = Bindable<[Movie]>([])
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchFavorites() {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            favorites.value = results.map(Movie.init)
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }

    func addToFavorites(movie: Movie, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let newFavorite = MovieEntity(context: context)
                newFavorite.id = Int64(movie.id)
                newFavorite.title = movie.title
                newFavorite.overview = movie.overview
                newFavorite.releaseDate = movie.releaseDate
                newFavorite.posterPath = movie.posterPath
                newFavorite.genreIDs = try? JSONEncoder().encode(movie.genreIDs)

                try context.save()
                completion(true) // Added successfully
            } else {
                // Movie already in favorites
                completion(false) // Not added because it's a duplicate
            }
        } catch {
            print("Could not add to favorites: \(error)")
            completion(false)
        }
    }

    func removeFromFavorites(at index: Int) {
        let movieToRemove = favorites.value[index]

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieToRemove.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let movieEntityToRemove = results.first as? MovieEntity {
                context.delete(movieEntityToRemove)
                try context.save()

                fetchFavorites()
            }
        } catch {
            print("Could not remove movie from favorites: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
