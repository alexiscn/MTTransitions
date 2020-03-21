//
//  FromViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2019/2/10.
//  Copyright © 2019 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class FromViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private var transtion: MTViewControllerTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let effect = MTHeartTransition()
        effect.ratio = Float(view.bounds.width / view.bounds.height)
            
        transtion = MTViewControllerTransition(transition: effect, duration: 2.0)
        

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.destination {
        case let toViewController as ToViewController:
            toViewController.transitioningDelegate = self
            toViewController.modalPresentationStyle = .custom
        default:
            break
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transtion
    }
 
}
