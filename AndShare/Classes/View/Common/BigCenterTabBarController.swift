//
//  BigCenterTabBarController.swift
//  AndShare
//
//  Created by USER on 2018/04/25.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class BigCenterTabBar1111Controller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // タブ真ん中にボタンを置く
        setupBigCenterButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // タブ真ん中のボタン作成
    private func setupBigCenterButton(){
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "center_button") , for: .normal)   // TODO:画像の用意
        button.sizeToFit()
        button.center = CGPoint(x: tabBar.bounds.size.width / 2, y: tabBar.bounds.size.height - (button.bounds.size.height/2))
//        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
        tabBar.addSubview(button)
    }
    
    // タブ真ん中を選択する
    func tapBigCenter(sender:AnyObject){
        selectedIndex = 2;
    }
}
