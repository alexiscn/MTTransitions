//
//  CreateVideoFromImagesViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/25.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class CreateVideoFromImagesViewController: UIViewController {

    private var movieWriter: MTMovieWriter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }
    
    private func createVideo() {
        var images: [UIImage] = []
        for i in 1 ... 9 {
            if let img = loadImage(named: "\(i)") {
                images.append(img)
            }
        }
        
        let path = NSTemporaryDirectory().appending("CreateVideoFromImages.mp4")
        let fileURL = URL(fileURLWithPath: path)
        movieWriter = MTMovieWriter(outputURL: fileURL)
        do {
            try movieWriter?.makeVideo(with: images, effect: .circleOpen, frameDuration: 2, transitionDuration: 0.5)
        } catch {
            print(error)
        }
        
    }
    
    private func loadImage(named: String) -> UIImage? {
        guard let path = Bundle.main.path(forResource: named, ofType: "jpg") else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }

}
