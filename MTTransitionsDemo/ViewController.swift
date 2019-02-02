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
    
    private var transition: MTTransition?
    private var context: MTIContext?
    private let generator = GifGenerator()
    
    private var index: Int = 0
    
    private var transitions: [MTTransition] = TransitionManager.shared.allTransitions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = try? MTIContext(device: MTLCreateSystemDefaultDevice()!)
        
        setupImageView()
        setupTransition()
    }
    
    private func setupImageView() {
        imageView = MTIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = resourceImage(named: "1")
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 400.0/512.0).isActive = true
    }
    
    private func setupTransition() {
        transition = transitions[index]
        transition?.inputImage = resourceImage(named: "1")
        transition?.destImage = resourceImage(named: "2")
    }

    @IBAction func buttonTapped(_ sender: Any) {
        doTransition()
    }
    
    private func doTransition() {
        
        setupTransition()
        
        // var images: [UIImage] = []
        var progress: Int = 0
        let t = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            progress += 1
            if progress >= 100 {
                
                timer.invalidate()
                self.index += 1
                if self.index < self.transitions.count {
                    self.doTransition()
                } else {
                    print("Finished")
                }
            }
            progress = min(100, progress)
            self.transition?.progress = Float(progress) / Float(100)
            self.imageView.image = self.transition?.outputImage
            
            if progress == 50, let image = self.imageView.image, let cgImage = try? self.context?.makeCGImage(from: image) {
                let img = UIImage(cgImage: cgImage!)
                if let data = img.jpegData(compressionQuality: 1.0) {
                    let name = NSStringFromClass(self.transition!.classForCoder)
                    let path = NSHomeDirectory().appending("/Documents/\(name).jpg")
                    let url = URL(fileURLWithPath: path)
                    try? data.write(to: url)
                }
            }

//            if let image = self.imageView.image, let cgImage = try? self.context?.makeCGImage(from: image) {
//                let img = UIImage(cgImage: cgImage!)
//                images.append(img)
//            }
        }
        t.fire()
    }
    
    private func generateGIFF(images: [UIImage], name: String) {
        let path = NSHomeDirectory().appending("/Documents/\(name).gif")
        let dest = URL(fileURLWithPath: path)
        self.generator.generateGifFromImages(imagesArray: images, frameDelay: 0.1, destinationURL: dest) { (data, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func resourceImage(named: String) -> MTIImage? {
        if let imageUrl = Bundle.main.url(forResource: named, withExtension: "jpg") {
            let ciImage = CIImage(contentsOf: imageUrl)
            return MTIImage(ciImage: ciImage!, isOpaque: true)
        }
        return nil
    }
}

