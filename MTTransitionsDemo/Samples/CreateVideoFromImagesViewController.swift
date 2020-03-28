//
//  CreateVideoFromImagesViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/25.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MetalPetal
import MTTransitions
import Photos

class CreateVideoFromImagesViewController: UIViewController {

    private var videoView: UIView!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var exportButton: UIBarButtonItem!
    
    private var fileURL: URL?
    private var movieWriter: MTMovieWriter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupSubviews()
        setupNavigationBar()
        createVideo()
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
            videoView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 400.0/512)
        ])
        
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
    }
    
    private func setupNavigationBar() {
        exportButton = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExportButtonClicked))
        exportButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = exportButton
    }
    
    private func createVideo() {
        var images: [MTIImage] = []
        
        for i in 1 ... 9 {
            if let img = loadImage(named: "\(i)") {
                images.append(img)
            }
        }
        let effects: [MTTransition.Effect] = [
        .circleOpen,
        .circleCrop,
        .heart,
        .crossZoom,
        .dreamy,
        .rotateScaleFade,
        .wipeDown,
        .wipeUp
        ]
        let path = NSTemporaryDirectory().appending("CreateVideoFromImages.mp4")
        let fileURL = URL(fileURLWithPath: path)
        movieWriter = MTMovieWriter(outputURL: fileURL)
        do {
            try movieWriter?.createVideo(with: images, effects: effects) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    self.fileURL = url
                    self.exportButton.isEnabled = true
                    let playerItem = AVPlayerItem(url: url)
                    self.player.replaceCurrentItem(with: playerItem)
                    self.player.play()
                    self.registerNotifications()
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func loadImage(named: String) -> MTIImage? {
        guard let url = Bundle.main.url(forResource: named, withExtension: "jpg") else {
            return nil
        }
        return MTIImage(contentsOf: url, options: [.SRGB: false])!.oriented(.downMirrored)
    }
    
    private func registerNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handlePlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }

    @objc private func handlePlayToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
    
    @objc private func handleExportButtonClicked() {
        guard let fileURL = self.fileURL else { return }
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
