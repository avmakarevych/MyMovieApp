//
//  MainTabBarController.swift
//  MyMovieApp
//
//  Created by Андрій Макаревич on 01.02.2024.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeAppearance()
    }

    private func setupViewControllers() {
        let moviesListVC = MoviesListViewController()

        moviesListVC.tabBarItem = UITabBarItem(
            title: "Movies List",
            image: UIImage(systemName: "film"),
            selectedImage: UIImage(systemName: "film.fill")
        )

        let favoritesVC = FavoritesViewController()

        favoritesVC.viewModel = FavoritesViewModel(context: CoreDataStack.shared.context)
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )

        viewControllers = [
            createNavController(for: moviesListVC, title: "Movies List", image: "film"),
            createNavController(for: favoritesVC, title: "Favorites", image: "star"),
        ]
    }

    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: String) -> UIViewController
    {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        navController.tabBarItem.selectedImage = UIImage(systemName: "\(image).fill")
        navController.navigationBar.prefersLargeTitles = true

        rootViewController.navigationItem.title = title

        return navController
    }

    private func customizeAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .systemBlue
    }
}
