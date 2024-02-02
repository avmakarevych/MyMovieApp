//
//  MovieDetailViewController.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var movie: Movie
    let genreProxy: GenreProxy
    let detailType: MovieDetailType

    // UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    let movieImageView = UIImageView()
    let titleLabel = UILabel()
    let genreLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseDateLabel = UILabel()

    init(movie: Movie, genreProxy: GenreProxy, detailType: MovieDetailType) {
        self.movie = movie
        self.genreProxy = genreProxy
        self.detailType = detailType
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupUI()

        genreProxy.fetchGenres {
            self.populateMovieDetails()
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupUI() {
        setupMovieImageView()
        setupTitleLabel()
        setupReleaseDateLabel()
        setupGenreLabel()
        setupOverviewLabel()
        layoutUIComponents()
    }

    private func setupMovieImageView() {
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 10
        movieImageView.layer.masksToBounds = true
        contentView.addSubview(movieImageView)
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }

    private func setupGenreLabel() {
        genreLabel.font = UIFont.systemFont(ofSize: 16)
        genreLabel.textColor = .secondaryLabel
        genreLabel.numberOfLines = 0
        contentView.addSubview(genreLabel)
    }

    private func setupOverviewLabel() {
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.textColor = .secondaryLabel
        overviewLabel.numberOfLines = 0
        contentView.addSubview(overviewLabel)
    }

    private func setupReleaseDateLabel() {
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .secondaryLabel
        contentView.addSubview(releaseDateLabel)
    }

    private func layoutUIComponents() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 200),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            genreLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    private func populateMovieDetails() {
        DispatchQueue.main.async {
            self.titleLabel.text = self.movie.title
            self.overviewLabel.text = self.movie.overview
            self.releaseDateLabel.text = "Release date: \(self.movie.releaseDate)"

            switch self.detailType {
            case .full:
                self.genreLabel.isHidden = true
            case .reduced:
                self.overviewLabel.isHidden = true
                self.genreLabel.text = "Genres: \(self.genreProxy.genreNames(fromIds: self.movie.genreIDs))"
            }

            if let posterPath = self.movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                self.loadImage(from: url)
            } else {
                self.movieImageView.image = UIImage(systemName: "film")
            }
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
        }.resume()
    }
}
