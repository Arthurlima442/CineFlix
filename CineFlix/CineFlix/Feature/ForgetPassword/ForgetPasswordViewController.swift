//
//  ForgetPasswordViewController.swift
//  CineFlix
//
//  Created by Arthur Lima on 24/06/2025.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    var screen: ForgetPasswordScreen?
    
    override func loadView() {
        screen = ForgetPasswordScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScreen()
    }
    
    func configScreen() {
        screen?.delegate = self
    }
}

extension ForgetPasswordViewController: ForgetPasswordScreenProtocol {
    func tappedConfirmButton() {
        print(#function)
    }
}
