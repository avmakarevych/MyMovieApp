//
//  MovieTableViewCell.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.numberOfLines = 2

        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 4

        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupViews() {
        addSubview(movieImageView)
        addSubview(titleLabel)
        addSubview(overviewLabel)
    }

    private func setupLayout() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 120),
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
        ])
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview

        if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            downloadImage(from: url)
        } else {
            movieImageView.image = UIImage(systemName: "film")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        }
    }

    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            }
        }.resume()
    }
}
