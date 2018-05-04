//
//  PTViewController.swift
//  SharePromote
//
//  Created by Bavaria on 2018/5/2.
//

import UIKit


class PTShareNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(rawValue: 7 << 16 | UIViewAnimationOptions.allowAnimatedContent.rawValue), animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
}


