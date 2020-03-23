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
    private var nameLabel: UILabel!
    private var pickButton: UIButton!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private let videoTransition = MTVideoTransition()
    private var clips: [AVAsset] = []
    private var exportButton: UIBarButtonItem!
    
    private var result: MTVideoTransitionResult?
    private var exporter: MTVideoExporter?
    
    private var effect = MTTransition.Effect.circleOpen
    
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
        
        nameLabel = UILabel()
        nameLabel.text = effect.description
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 15)
        ])
        
        pickButton = UIButton(type: .system)
        pickButton.setTitle("Pick A Transition", for: .normal)
        view.addSubview(pickButton)
        
        pickButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickButton.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 30),
            pickButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
        pickButton.addTarget(self, action: #selector(handlePickButtonClicked), for: .touchUpInside)
    }
    
    @objc private func handlePickButtonClicked() {
        let pickerVC = TransitionsPickerViewController()
        pickerVC.selectionUpdated = { [weak self] effect in
            guard let self = self else { return }
            self.effect = effect
            self.nameLabel.text = effect.description
            self.result = nil
            self.exportButton.isEnabled = false
        }
        let nav = UINavigationController(rootViewController: pickerVC)
        present(nav, animated: true, completion: nil)
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
        
        exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExportButtonClicked))
        exportButton.isEnabled = false
        
        navigationItem.rightBarButtonItems = [actionButton, exportButton]
    }
    
    @objc private func handleActionButtonClicked() {
        let duration = CMTimeMakeWithSeconds(2.0, preferredTimescale: 1000)
        videoTransition.makeTransition(with: clips, effect: effect, transitionDuration: duration) { result in
            let playerItem = AVPlayerItem(asset: result.composition)
            playerItem.videoComposition = result.videoComposition
            
            self.player.seek(to: .zero)
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
            
            self.result = result
            self.exportButton.isEnabled = true
        }
    }
    
    @objc private func handleExportButtonClicked() {
        guard let result = result else {
            return
        }
        self.export(result)
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
