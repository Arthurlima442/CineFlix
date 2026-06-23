import Foundation
import FirebaseAuth

protocol SettingsViewModelProtocol: AnyObject {
    func accountDeletedSuccessfully()
    func accountDeletionFailed(message: String)
}

class SettingsViewModel {
    
    weak var delegate: SettingsViewModelProtocol?
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            delegate?.accountDeletionFailed(message: "No user is currently logged in.")
            return
        }

        user.delete { error in
            if let error = error {
                print("❌ Failed to delete account: \(error.localizedDescription)")
                self.delegate?.accountDeletionFailed(message: error.localizedDescription)
            } else {
                print("✅ Account successfully deleted.")
                self.delegate?.accountDeletedSuccessfully()
            }
        }
    }
}
