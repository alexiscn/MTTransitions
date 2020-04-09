//
//  PickImageTransitionViewController.swift
//  MTTransitionsDemo
//
//  Created by xu.shuifeng on 2020/4/9.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MetalPetal
import MTTransitions

class PickImageTransitionViewController: UIViewController {

    private var imageView: MTIImageView!
    
    private var nameLabel: UILabel!
    
    private var pickButton: UIButton!
    
    private var fromImage: MTIImage!
    private var toImage: MTIImage!
    
    private var effect: MTTransition.Effect = .angular
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureImages()
        configureSubviews()
        doTransition()
    }
    
    private func configureImages() {
        func loadImage(named: String) -> MTIImage {
            let imageUrl = Bundle.main.url(forResource: named, withExtension: "jpg")!
            return MTIImage(contentsOf: imageUrl, options: [.SRGB: false])!.oriented(.downMirrored)
        }
        fromImage = loadImage(named: "1")
        toImage = loadImage(named: "2")
    }

    private func configureSubviews() {
        imageView = MTIImageView(frame: .zero)
        imageView.image = fromImage.oriented(.downMirrored)
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
    
    private func doTransition() {
        let transition = effect.transition
        transition.duration = 2.0
        transition.transition(from: fromImage, to: toImage, updater: { [weak self] image in
            self?.imageView.image = image
        }, completion: nil)
        
        let name = NSStringFromClass(transition.classForCoder).replacingOccurrences(of: "MTTransitions.", with: "")
        nameLabel.text = name
    }
    
    @objc private func handlePickButtonClicked() {
        let pickerVC = TransitionsPickerViewController()
        pickerVC.selectionUpdated = { [weak self] effect in
            guard let self = self else { return }
            self.effect = effect
            self.doTransition()
        }
        let nav = UINavigationController(rootViewController: pickerVC)
        present(nav, animated: true, completion: nil)
    }
}
