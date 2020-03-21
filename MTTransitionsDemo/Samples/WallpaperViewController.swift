//
//  WallpaperViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit

class WallpaperViewController: UIViewController {
    
    var wallpaper: String { return "wallpaper01.jpg" }
    
    private var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureSubviews()
    }

    private func configureSubviews() {
        backgroundImageView = UIImageView()
        backgroundImageView.clipsToBounds = true
        backgroundImageView.isUserInteractionEnabled = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: wallpaper)
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
