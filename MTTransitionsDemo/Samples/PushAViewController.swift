//
//  PushAViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class PushAViewController: WallpaperViewController {

    private let transition = MTViewControllerTransition(transition: MTBurnTransition())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction() {
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
