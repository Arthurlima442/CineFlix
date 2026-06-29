//
//  TabBarController.swift
//  CineFlix
//
//  Created by Arthur Lima on 22/06/2025.
//
import UIKit

class TabBarController: UITabBarController {
    
    private var previousIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeAppearance()
        
        // Implementar UITabBarControllerDelegate para reset de abas
        self.delegate = self
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

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        // Adicionar animação suave ao mudar de aba
        if tabBarController.selectedViewController != nil {
            // Fade suave entre as abas
            UIView.transition(
                with: tabBarController.view,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
        return true
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        let currentIndex = tabBarController.selectedIndex
        
        // Resetar estado quando trocar de aba
        if currentIndex != previousIndex {
            handleTabReset(at: currentIndex)
        }
        
        previousIndex = currentIndex
    }
    
    private func handleTabReset(at index: Int) {
        guard let navController = viewControllers?[index] as? UINavigationController else { return }
        guard let rootVC = navController.viewControllers.first else { return }
        
        // Resetar Home (aba 0)
        if index == 0, let homeVC = rootVC as? HomeViewController {
            resetHomeViewController(homeVC)
        }
        
        // Resetar Series (aba 1)
        if index == 1, let seriesVC = rootVC as? SeriesViewController {
            resetSeriesViewController(seriesVC)
        }
    }
    
    private func resetHomeViewController(_ viewController: HomeViewController) {
        // Limpar search e teclado
        viewController.screen?.searchBar.text = ""
        viewController.screen?.searchBar.resignFirstResponder()
        
        // Limpar estado de busca no ViewModel
        viewController.viewModel.clearSearch()
        
        // Recarregar seções principais
        viewController.viewModel.setupInitialSections()
        viewController.viewModel.loadMainSectionsOnly()
        
        // Voltar ao topo da TableView
        viewController.screen?.tableView.setContentOffset(.zero, animated: false)
        
        // Recarregar dados
        DispatchQueue.main.async {
            viewController.screen?.tableView.reloadData()
        }
    }
    
    private func resetSeriesViewController(_ viewController: SeriesViewController) {
        // Limpar search e teclado
        viewController.screen?.searchBar.text = ""
        viewController.screen?.searchBar.resignFirstResponder()
        
        // Limpar estado de busca no ViewModel
        viewController.viewModel.clearSearch()
        
        // Recarregar seções principais
        viewController.viewModel.setupInitialSections()
        viewController.viewModel.loadMainSectionsOnly()
        
        // Voltar ao topo da TableView
        viewController.screen?.tableView.setContentOffset(.zero, animated: false)
        
        // Recarregar dados
        DispatchQueue.main.async {
            viewController.screen?.tableView.reloadData()
        }
    }
}
