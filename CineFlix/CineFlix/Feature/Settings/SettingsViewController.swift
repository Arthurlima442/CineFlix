import UIKit

class SettingsViewController: UIViewController {
    
    var screen: SettingsScreen?
    var viewModel: SettingsViewModel = SettingsViewModel()
    
    override func loadView() {
        screen = SettingsScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
        configViewModal()
    }
    
    func configViewModal() {
        viewModel.delegate = self
    }
    
    func configScreen() {
        screen?.delegate = self
    }
}

// MARK: - SettingsScreenProtocol
extension SettingsViewController: SettingsScreenProtocol {
    
    func tappedExitAppButton() {
        let alert = UIAlertController(
            title: "Exit the App",
            message: "Do you really want to leave?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive) { _ in
            let loginVC = ChooseSignInViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            }
        })
        
        present(alert, animated: true)
    }
    
    func tappedDeleteAccontButton() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to permanently delete your account?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteAccount()
        })
        
        present(alert, animated: true)
    }
}

extension SettingsViewController: SettingsViewModelProtocol {
    func accountDeletedSuccessfully() {
        let loginVC = ChooseSignInViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
        }
    }
    
    func accountDeletionFailed(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
