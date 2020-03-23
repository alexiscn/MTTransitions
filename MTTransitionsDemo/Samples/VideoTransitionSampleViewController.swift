//
//  VideoTransitionSampleViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/22.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import AVFoundation
import MTTransitions
import Photos

class VideoTransitionSampleViewController: UIViewController {

    private var videoView: UIView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private let videoTransition = MTVideoTransition()
    private var clips: [AVAsset] = []
    
    private var exporter: MTVideoExporter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupVideoPlaybacks()
        setupSubviews()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handlePlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = videoView.bounds
    }
    
    private func setupSubviews() {
        
        videoView = UIView()
        view.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            videoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            videoView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 720.0/1280.0)
        ])
        
        let url = Bundle.main.url(forResource: "clip1", withExtension: "mp4")!
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
    }
    
    @objc private func handlePlayToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
    
    private func setupVideoPlaybacks() {
        guard let clip1 = loadVideoAsset(named: "clip1"),
            let clip2 = loadVideoAsset(named: "clip2") else {
            return
        }
        clips = [clip1, clip2]
    }
    
    private func loadVideoAsset(named: String, withExtension ext: String = "mp4") -> AVURLAsset? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            return nil
        }
        return AVURLAsset(url: url)
    }

    private func setupNavigationBar() {
        let actionButton = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(handleActionButtonClicked))
        navigationItem.rightBarButtonItem = actionButton
    }
    
    @objc private func handleActionButtonClicked() {
        let effect = MTTransition.Effect.burn
        let duration = CMTimeMakeWithSeconds(2.0, preferredTimescale: 1000)
        videoTransition.transitionDuration = duration
        videoTransition.makeTransition(with: clips, effect: effect) { result in
            
            let playerItem = AVPlayerItem(asset: result.composition)
            playerItem.videoComposition = result.videoComposition
            
            self.player.seek(to: .zero)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
            
            //self.export(result)
        }
    }
    
    private func export(_ result: MTVideoTransitionResult) {
        exporter = try? MTVideoExporter(transitionResult: result)
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("exported.mp4"))
        exporter?.export(to: fileURL, completion: { error in
            if let error = error {
                print("Export error:\(error)")
            } else {
                self.saveVideo(fileURL: fileURL)
            }
        })
    }
    
    private func saveVideo(fileURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .video, fileURL: fileURL, options: options)
                }) { (success, error) in
                    print("Saved to camera roll")
                }
            default:
                break
            }
        }
    }
}
