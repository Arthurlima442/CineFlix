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
}
