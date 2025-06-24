//
//  SettingsViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 10/06/2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var screen: SettingsScreen?
    
    override func loadView() {
        screen = SettingsScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
        view.backgroundColor = .black
    }
    
    private func configScreen() {
        screen?.delegate = self
    }
}
extension SettingsViewController: SettingsScreenProtocol {
    
    func tappedExitAppButton() {
        let alert = UIAlertController(
            title: "Sair do App",
            message: "Você deseja mesmo sair?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive) { _ in
            let loginVC = ChooseSignInViewController()
            let navController = UINavigationController(rootViewController: loginVC)

            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
            }
        })
        
        present(alert, animated: true)
    }
    
    func tappedDeleteAccontButton() {
        let alert = UIAlertController(
            title: "Deletar Conta",
            message: "Tem certeza que deseja deletar sua conta? Essa ação não pode ser desfeita.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Deletar", style: .destructive) { _ in
            // Aqui você pode limpar dados de usuário, fazer logout etc.
            let loginVC = ChooseSignInViewController()
            let navController = UINavigationController(rootViewController: loginVC)
//            navController.navigationBar.isHidden = true
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
            }
        })
        
        present(alert, animated: true)
    }
}





