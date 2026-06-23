//
//  TabBarController.swift
//  CineFlix
//
//  Created by Arthur Lima on 22/06/2025.
//
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeAppearance()
    }
    
    private func setupTabBar() {
        let home = createNavController(viewController: HomeViewController(), title: "Home", imageName: "house", selectedImage: "house.fill")
        let series = createNavController(viewController: SeriesViewController(), title: "Series", imageName: "tv", selectedImage: "tv.fill")
        let settings = createNavController(viewController: SettingsViewController(), title: "Config", imageName: "gear", selectedImage: "gearshape.fill")
        
        viewControllers = [home, series, settings]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String, selectedImage: String) -> UINavigationController {
      let navController = UINavigationController(rootViewController: viewController)
      navController.tabBarItem.title = title
      navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
      return navController
    }
    
    private func customizeAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

        appearance.shadowColor = UIColor.white.withAlphaComponent(0.3)

        appearance.stackedLayoutAppearance.selected.iconColor = .red
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red]

        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
