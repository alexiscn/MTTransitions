//
//  PresentAViewController.swift
//  MTTransitionsDemo
//
//  Created by alexiscn on 2020/3/21.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import MTTransitions

class PresentAViewController: WallpaperViewController {
    
    private let transtion = MTViewControllerTransition(transition: MTCrossHatchTransition())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButton = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(handleActionButtonClicked))
        navigationItem.rightBarButtonItem = actionButton
    }
    
    @objc private func handleActionButtonClicked() {
        let vc = PresentBViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension PresentAViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
}
