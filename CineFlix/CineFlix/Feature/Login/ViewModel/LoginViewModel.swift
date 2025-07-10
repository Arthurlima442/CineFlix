import Foundation
import FirebaseAuth

protocol LoginViewModelProtocol: AnyObject {
    func loginSuccess()
    func loginError(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelProtocol?

    func login(email: String, password: String) {
        guard isValidEmail(email) else {
            delegate?.loginError(message: "Invalid email format.")
            return
        }

        guard isValidPassword(password) else {
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

    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
