//
//  MultipleVideoTransitionsViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/25.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import AVFoundation
import MTTransitions
import Photos

class MultipleVideoTransitionsViewController: UIViewController {

    private var videoView: UIView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private let videoTransition = MTVideoTransition()
    private var clips: [AVAsset] = []
    private var exportButton: UIBarButtonItem!
    
    private var result: MTVideoTransitionResult?
    private var exporter: MTVideoExporter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupVideoPlaybacks()
        setupSubviews()
        setupNavigationBar()
        makeTransition()
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
            videoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80),
            videoView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 720.0/1280.0)
        ])
        
        let url = Bundle.main.url(forResource: "cut1", withExtension: "mp4")!
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)

    }

    private func setupVideoPlaybacks() {
        guard let clip1 = loadVideoAsset(named: "cut1"),
            let clip2 = loadVideoAsset(named: "cut2"),
            let clip3 = loadVideoAsset(named: "cut3"),
            let clip4 = loadVideoAsset(named: "clip1") else {
            return
        }
        clips = [clip1, clip2, clip3, clip4]
    }

    private func setupNavigationBar() {
        exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExportButtonClicked))
        exportButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = exportButton
    }
    
    private func makeTransition() {
        let duration = CMTimeMakeWithSeconds(2.0, preferredTimescale: 1000)
        let effects: [MTTransition.Effect] = [.squaresWire, .circleOpen, .burn]
        try? videoTransition.merge(clips, effects: effects, transitionDuration: duration) { [weak self] result in
            guard let self = self else { return }
            let playerItem = AVPlayerItem(asset: result.composition)
            playerItem.videoComposition = result.videoComposition
            
            self.player.seek(to: .zero)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
            
            self.registerNotifications()
            
            self.result = result
            self.exportButton.isEnabled = true
        }
        
        // comment upside codes and uncomment following code to see multiple effects.
        // makeTransitionsWithMultipleEffects()
    }
   
    private func registerNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handlePlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
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
                    DispatchQueue.main.async {
                        if success {
                            let alert = UIAlertController(title: "Video Saved To Camera Roll", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            default:
                print("PhotoLibrary not authorized")
                break
            }
        }
    }
}

// MARK: - Events
extension MultipleVideoTransitionsViewController {
    
    @objc private func handleExportButtonClicked() {
        guard let result = result else {
            return
        }
        self.export(result)
    }
    
    @objc private func handlePlayToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
}

// MARK: - Helper
extension MultipleVideoTransitionsViewController {
    
    private func loadVideoAsset(named: String, withExtension ext: String = "mp4") -> AVURLAsset? {
        guard let url = Bundle.main.url(forResource: named, withExtension: ext) else {
            return nil
        }
        return AVURLAsset(url: url)
    }
}
