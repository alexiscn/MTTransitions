//
//  PresentBViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit

class PresentBViewController: WallpaperViewController {
    
    override var wallpaper: String { return "wallpaper02.jpg" }
    
    private var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(handleActionButtonClicked), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc private func handleActionButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}
