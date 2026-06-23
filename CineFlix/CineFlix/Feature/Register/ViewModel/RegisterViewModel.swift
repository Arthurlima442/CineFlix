import Foundation
import FirebaseAuth

protocol RegisterViewModelProtocol: AnyObject {
    func showAlert(message: String)
    func registerSuccess()
}

class RegisterViewModel {
    
    weak var delegate: RegisterViewModelProtocol?
    
    func validateFields(email: String, password: String, confirmPassword: String) {
        guard ValidationHelper.isValidEmail(email) else {
            delegate?.showAlert(message: "Please enter a valid email.")
            return
        }
        
        guard ValidationHelper.isValidPassword(password) else {
            delegate?.showAlert(message: "Password must be at least 6 characters.")
            return
        }

        guard password == confirmPassword else {
            delegate?.showAlert(message: "Passwords do not match.")
            return
        }
        
        createUser(email: email, password: password)
    }
    
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.delegate?.showAlert(message: "Registration failed: \(error.localizedDescription)")
            } else {
                self.delegate?.registerSuccess()
            }
        }
    }
}
