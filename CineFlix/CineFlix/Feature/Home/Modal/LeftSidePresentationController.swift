//
//  LeftSidePresentationController.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//
import UIKit

class LeftSidePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let width = container.bounds.width * 0.7 // ocupa 70% da tela
        return CGRect(x: 0, y: 0, width: width, height: container.bounds.height)
    }
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0.0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }

        dimmingView.frame = container.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.insertSubview(dimmingView, at: 0)

        // Fecha modal ao tocar fora
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        dimmingView.addGestureRecognizer(tap)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
