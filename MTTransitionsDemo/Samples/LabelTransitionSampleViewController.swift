//
//  LabelTransitionSampleViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class LabelTransitionSampleViewController: UIViewController {

    private var label: UILabel!
    
    private var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "UILabel Transitions"
        view.backgroundColor = .white
        
        configureSubviews()
    }

    private func configureSubviews() {
        label = UILabel()
        label.text = "Sample text"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        actionButton = UIButton(type: .system)
        actionButton.setTitle("Do Transition", for: .normal)
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
        actionButton.addTarget(self, action: #selector(actionButtonClicked), for: .touchUpInside)
    }
    
    @objc private func actionButtonClicked() {
        let effect = MTPerlinTransition()
        
        MTTransition.transition(with: label, effect: effect, animations: {
            if self.label.textColor == .black {
                self.label.text = "Sample text"
                self.label.textColor = .blue
            } else {
                self.label.text = "Test label"
                self.label.textColor = .black
            }
        }) { (_) in
            print("Transition finished")
        }
    }
    
}
