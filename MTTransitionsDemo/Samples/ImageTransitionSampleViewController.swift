//
//  ImageTransitionSampleViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/21.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MetalPetal
import MTTransitions

class ImageTransitionSampleViewController: UIViewController {

    private var imageView: MTIImageView!
    
    private var nameLabel: UILabel!
    
    private let duration: Double = 2.0
    
    private var fromIndex: Int = 0
    
    private var toIndex: Int = 1
    
    private var transitionIndex: Int = 0
    
    private var transition: MTTransition?
    
    private var transitions: [MTTransition] = TransitionManager.shared.allTransitions
    
    private var sampleImages: [MTIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Image Transitions"
        view.backgroundColor = .white
        
        fromIndex = 0
        toIndex = Int.random(in: 1...8)
        configureSampleImages()
        configureSubviews()
        
        doTransition()
    }
    
    private func configureSampleImages() {
        for i in 1...9 {
            if let imageUrl = Bundle.main.url(forResource: String(i), withExtension: "jpg") {
                let image = MTIImage(contentsOf: imageUrl, options: [.SRGB: false])!.oriented(.downMirrored)
                sampleImages.append(image)
            }
        }
    }
    
    private func configureSubviews() {
        imageView = MTIImageView(frame: .zero)
        imageView.image = sampleImages[fromIndex]
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 512.0/400),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60)
        ])
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }

    private func doTransition() {
        transition = transitions[transitionIndex]
        transition?.duration = duration
        transition?.ratio = Float(512.0/400.0)
        transition?.transition(from: sampleImages[fromIndex], to: sampleImages[toIndex], updater: { image in
            self.imageView.image = image
        }, completion: { _ in
            self.doNextTransition()
        })
        
        let name = NSStringFromClass(transition!.classForCoder).replacingOccurrences(of: "MTTransitions.", with: "")
        nameLabel.text = name
    }
    
    private func doNextTransition() {
        transitionIndex = (transitionIndex + 1) % transitions.count
        fromIndex = toIndex
        var to = Int.random(in: 0...8)
        while to == self.fromIndex {
            to = Int.random(in: 0...8)
        }
        toIndex = to
        doTransition()
    }
}
