//
//  AppTransition.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2026.
//

import UIKit

class AppTransition {
    
    private init() {}
    
    /// Muda o root view controller da aplicação com animação
    /// - Parameters:
    ///   - viewController: O novo controlador raiz
    ///   - options: Opções de animação (padrão: transição cruzada com dissolve)
    static func changeRootViewController(
        to viewController: UIViewController,
        with options: UIView.AnimationOptions = .transitionCrossDissolve
    ) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("⚠️ Warning: Could not change root view controller - Scene delegate or window not found")
            return
        }
        
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.5, options: options, animations: nil)
    }
}
