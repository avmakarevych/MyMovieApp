//
//  MoviesListViewController.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import Foundation
import UIKit

class MoviesListViewController: BaseViewController {
    var viewModel: MoviesListViewModel = .init(networkManager: NetworkManager())
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupRefreshControl()
        setupLongPressGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMovies()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func bindViewModel() {
        viewModel.movies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshMoviesData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl // iOS 10+ only
    }

    @objc private func refreshMoviesData(_: Any) {
        viewModel.movies.value = []
        viewModel.currentPage = 1
        viewModel.hasMoreMovies = true
        viewModel.fetchMovies()

        refreshControl.endRefreshing()
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let movie = viewModel.movies.value[indexPath.row]
                addToFavorites(movie: movie)
            }
        }
    }

    func addToFavorites(movie: Movie) {
        let favoritesViewModel = FavoritesViewModel(context: CoreDataStack.shared.context)
        favoritesViewModel.addToFavorites(movie: movie) { [weak self] addedSuccessfully in
            guard let strongSelf = self else { return }

            if addedSuccessfully {
                strongSelf.showAlert(with: "Success", message: "\(movie.title) has been added to your Favorites.")
            } else {
                strongSelf.showAlert(with: "Duplicate", message: "\(movie.title) is already in your Favorites.")
            }
        }
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.movies.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.movies.value[indexPath.row]

        cell.configure(with: movie)

        return cell
    }
}

extension MoviesListViewController {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies.value[indexPath.row]
        let detailVC = MovieDetailViewController(movie: movie, genreProxy: GenreProxy(networkManager: NetworkManager()), detailType: .full)

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            viewModel.fetchMovies()
        }
    }
}
