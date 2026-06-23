import Foundation
import FirebaseAuth

protocol LoginViewModelProtocol: AnyObject {
    func loginSuccess()
    func loginError(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelProtocol?

    func login(email: String, password: String) {
        guard ValidationHelper.isValidEmail(email) else {
            delegate?.loginError(message: "Invalid email format.")
            return
        }

        guard ValidationHelper.isValidPassword(password) else {
            delegate?.loginError(message: "Password must be at least 6 characters.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ Login failed: \(error.localizedDescription)")
                self.delegate?.loginError(message: error.localizedDescription)
            } else {
                print("✅ Login successful.")
                self.delegate?.loginSuccess()
            }
        }
    }
}
