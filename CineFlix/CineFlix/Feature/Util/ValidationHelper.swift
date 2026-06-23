//
//  ValidationHelper.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import Foundation

class ValidationHelper {
    
    private init() {}
    
    /// Valida se um email está em formato correto
    /// - Parameter email: String com o email a validar
    /// - Returns: true se o email é válido, false caso contrário
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    /// Valida se uma senha atende aos requisitos mínimos
    /// - Parameter password: String com a senha a validar
    /// - Returns: true se a senha tem pelo menos 6 caracteres, false caso contrário
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
