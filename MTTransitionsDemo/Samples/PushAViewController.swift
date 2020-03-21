//
//  PushAViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class PushAViewController: UIViewController {

    private var backgroundImageView: UIImageView!
    
    private let transition = MTViewControllerTransition(transition: MTBurnTransition())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
        
        navigationController?.delegate = self
    }
    
    @objc private func tapAction() {
        let vc = PushBViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureSubviews() {
        backgroundImageView = UIImageView()
        backgroundImageView.isUserInteractionEnabled = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "wallpaper01.jpg")
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
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
