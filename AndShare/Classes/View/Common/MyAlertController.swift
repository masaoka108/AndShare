//
//  MyAlertController.swift
//  AndShare
//
//  Created by USER on 2018/05/06.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import Foundation
import UIKit

class MyAlertController: UIAlertController {
    
    public var customView: UIView?
    public var customViewMarginBottom: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let customView = self.customView else {
            return
        }

        customView.frame.origin.y = -customView.frame.height - self.customViewMarginBottom
        customView.frame.origin.y = 0

        self.view.addSubview(customView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let customView = self.customView else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            customView.alpha = 0
        }
    }
}
