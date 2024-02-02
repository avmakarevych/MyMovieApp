//
//  FavoritesViewController.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import UIKit

class FavoritesViewController: BaseViewController {
    var viewModel: FavoritesViewModel = .init(context: CoreDataStack.shared.context)
    let emptyStateLabel = StyledLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyStateLabel)

        bindViewModel()
        setupLongPressGesture()
        setupEmptyStateLabel()
    }

    private func setupEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    private func bindViewModel() {
        viewModel.favorites.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.emptyStateLabel.isHidden = !(self?.viewModel.favorites.value.isEmpty ?? true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                let alert = UIAlertController(title: "Confirm Deletion",
                                              message: "Are you sure you want to remove this movie from favorites?",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in

                    self?.viewModel.removeFromFavorites(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }))
                present(alert, animated: true)
            }
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.favorites.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        let movie = viewModel.favorites.value[indexPath.row]

        cell?.configure(with: movie)

        return cell ?? UITableViewCell()
    }
}

extension FavoritesViewController {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.favorites.value[indexPath.row]
        let detailVC = MovieDetailViewController(movie: movie, genreProxy: GenreProxy(networkManager: NetworkManager()), detailType: .reduced)

        navigationController?.pushViewController(detailVC, animated: true)
    }
}
