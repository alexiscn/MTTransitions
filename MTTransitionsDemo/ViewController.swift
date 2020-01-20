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

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var testLabel: UILabel!

    private var imageView: MTIImageView!
    
    private let duration: Double = 2.0
    
    private var fromIndex: Int = 0
    
    private var toIndex: Int = 1
    
    private var transitionIndex: Int = 0
    
    private var transition: MTTransition?
    
    private var transitions: [MTTransition] = TransitionManager.shared.allTransitions
    
    private var sampleImages: [MTIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromIndex = 0
        toIndex = Int.random(in: 1...8)
        setupSampleImages()
        setupImageView()
        
        doTransition()
    }
    
    private func setupImageView() {
        imageView = MTIImageView(frame: containerView.bounds)
        imageView.image = sampleImages[fromIndex]
        containerView.addSubview(imageView)
    }
    
    private func setupSampleImages() {
        for i in 1...9 {
            if let imageUrl = Bundle.main.url(forResource: String(i), withExtension: "jpg") {
                let image = MTIImage(contentsOf: imageUrl, options: [
                    .origin : MTKTextureLoader.Origin.bottomLeft,
                    .SRGB: false])!
                sampleImages.append(image)
            }
        }
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
        
        nameLabel.text = NSStringFromClass(transition!.classForCoder).replacingOccurrences(of: "MTTransitions.", with: "")
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
    
    @IBAction func testButtonPressed(_ sender: Any) {
        let effect = MTPerlinTransition()
        
        MTTransition.transition(with: testLabel, effect: effect, animations: {
            if self.testLabel.textColor == .black {
                self.testLabel.text = "Sample text"
                self.testLabel.textColor = .blue
            } else {
                self.testLabel.text = "Test label"
                self.testLabel.textColor = .black
            }
        }) { (_) in
            print("Transition finished")
        }
    }
}

