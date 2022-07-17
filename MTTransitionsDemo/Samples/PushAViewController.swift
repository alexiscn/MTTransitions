//
//  PushAViewController.swift
//  MTTransitionsDemo
//
//  Created by alexiscn on 2020/3/21.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit
import MTTransitions

class PushAViewController: WallpaperViewController {

    private let transition = MTViewControllerTransition(effect: .displacement)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let actionButton = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(handleActionButtonClicked))
        navigationItem.rightBarButtonItem = actionButton
    }
        
    @objc private func handleActionButtonClicked() {
        let vc = PushBViewController()
        navigationController?.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PushAViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return transition
        }
        return nil
    }
    
}
