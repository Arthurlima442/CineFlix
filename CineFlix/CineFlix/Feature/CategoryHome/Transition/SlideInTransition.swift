//
//  SlideInTransition.swift
//  CineFlix
//
//  Created by Arthur Lima on 23/06/2025.
//
import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        if isPresenting, let toView = transitionContext.view(forKey: .to) {
            let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            toView.frame = finalFrame.offsetBy(dx: -finalFrame.width, dy: 0) // começa fora da tela à esquerda
            container.addSubview(toView)

            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                toView.frame = finalFrame
            } completion: { finished in
                transitionContext.completeTransition(finished)
            }

        } else if let fromView = transitionContext.view(forKey: .from) {
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                fromView.frame = fromView.frame.offsetBy(dx: -fromView.frame.width, dy: 0)
            } completion: { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
}
