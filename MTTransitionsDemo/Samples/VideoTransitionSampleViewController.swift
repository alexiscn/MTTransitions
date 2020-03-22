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

class VideoTransitionSampleViewController: UIViewController {

    private var videoView: UIView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private let videoTransition = MTVideoTransition()
    private var clips: [AVAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupVideoPlaybacks()
        setupSubviews()
        setupNavigationBar()
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
            videoView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 544.0/1280.0)
        ])
        
        let url = Bundle.main.url(forResource: "video1", withExtension: "mp4")!
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        
        player.play()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc private func handlePlayToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
    
    private func setupVideoPlaybacks() {
        guard let clip1 = loadVideoAsset(named: "video1"),
            let clip2 = loadVideoAsset(named: "video2"),
            let clip3 = loadVideoAsset(named: "video3") else {
            return
        }
        clips = [clip1, clip2, clip3]
    }
    
    private func loadVideoAsset(named: String) -> AVURLAsset? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "mp4") else {
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
        let duration = CMTimeMakeWithSeconds(2.0, preferredTimescale: 600)
        videoTransition.transitionDuration = duration
        videoTransition.makeTransition(with: clips, effect: effect) { playerItem in
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
        }
    }
}
