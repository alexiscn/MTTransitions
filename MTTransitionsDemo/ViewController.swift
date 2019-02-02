//
//  ViewController.swift
//  MTTransitionsDemo
//
//  Created by xu.shuifeng on 2019/1/24.
//  Copyright © 2019 xu.shuifeng. All rights reserved.
//

import UIKit
import MetalPetal
import MTTransitions

class ViewController: UIViewController {

    private var imageView: MTIImageView!
    
    private let duration: Double = 2.0
    
    private var fromIndex: Int = 0
    private var toIndex: Int = 1
    
    private weak var timer: CADisplayLink?
    private var startTime: CFTimeInterval?
    
    private var index: Int = 0
    
    private var transition: MTTransition?
    private var transitions: [MTTransition] = TransitionManager.shared.allTransitions
    private var images: [MTIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromIndex = 0
        toIndex = Int.random(in: 1...8)
        setupImages()
        setupImageView()
        setupTransition()
        setupTimer()
    }
    
    private func setupImageView() {
        imageView = MTIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = images[fromIndex]
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 400.0/512.0).isActive = true
    }
    
    private func setupImages() {
        for i in 1...9 {
            if let imageUrl = Bundle.main.url(forResource: String(i), withExtension: "jpg") {
                let ciImage = CIImage(contentsOf: imageUrl)
                images.append(MTIImage(ciImage: ciImage!, isOpaque: true))
            }
        }
    }
    
    private func setupTimer() {
        let timer = CADisplayLink(target: self, selector: #selector(render))
        timer.add(to: .main, forMode: .common)
        self.timer = timer
    }
    
    @objc private func render(sender: CADisplayLink) {
        let startTime: CFTimeInterval
        if let time = self.startTime {
            startTime = time
        } else {
            startTime = sender.timestamp
            self.startTime = startTime
        }
        
        var progress = (sender.timestamp - startTime) / duration
        if progress > 1 {
            update(progress: 1.0)
            
            self.startTime = nil
            index += 1
            if index < transitions.count {
                self.fromIndex = self.toIndex
                var i = Int.random(in: 0...8)
                while i == self.fromIndex {
                     i = Int.random(in: 0...8)
                }
                self.toIndex = i
                setupTransition()
            } else {
                self.timer?.invalidate()
                self.timer = nil
                print("Finished")
            }
            return
        }
        progress = min(progress, 1.0)
        update(progress: Float(progress))
    }
    
    private func update(progress: Float) {
        transition?.progress = progress
        imageView.image = self.transition?.outputImage
    }
    
    private func setupTransition() {
        transition = transitions[index]
        transition?.inputImage = images[fromIndex]
        transition?.destImage = images[toIndex]
        //imageView.image = images[fromIndex]
    }
    
//    private func generateThumbnails(_ image: UIImage) {
//        if let data = image.jpegData(compressionQuality: 1.0) {
//            let name = NSStringFromClass(self.transition!.classForCoder)
//            let path = NSHomeDirectory().appending("/Documents/\(name).jpg")
//            let url = URL(fileURLWithPath: path)
//            try? data.write(to: url)
//        }
//    }
}

