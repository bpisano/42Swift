//
//  FTLoadingAnimatorView.swift
//  42Swift
//
//  Created by Benjamin Pisano on 27/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import UIKit

class FTLoadingAnimatorView: UIView {
    
    @IBOutlet weak var view1: UIView!
    
    override func awakeFromNib() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        animate()
    }
    
    func addLoadingAnimator(in view: UIView?) {
        guard view != nil else {
            return
        }
        
        guard let animator = Bundle.main.loadNibNamed("FTLoadingAnimator", owner: self, options: nil)?.first as? FTLoadingAnimatorView else {
            return
        }
        
        let xPosition = (view!.frame.width / 2) - (150 / 2)
        let yPosition = (view!.frame.height / 2) - (150 / 2) + 40
        
        animator.frame = CGRect(x: xPosition, y: yPosition, width: 150, height: 150)
        animator.restorationIdentifier = "loadingAnimator"
        view!.addSubview(animator)
    }
    
    func removeLoadingAnimator(from view: UIView?) {
        guard view != nil else {
            return
        }
        
        for subview in view!.subviews {
            if subview.restorationIdentifier == "loadingAnimator" {
                subview.removeFromSuperview()
                return
            }
        }
    }
    
    private func animate() {
        let max: UInt32 = 14
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (_) in
            let space = arc4random() % 5
            var random = arc4random() % max + 1
            if space == 0 {
                random = 12
            }
            if let key = self.viewWithTag(Int(random)) {
                key.alpha = 0.2
                UIView.animate(withDuration: 0.2, animations: {
                    key.alpha = 1
                })
            }
        }
    }

}
