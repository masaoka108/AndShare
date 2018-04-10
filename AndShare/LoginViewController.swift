//
//  ViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //******** 背景色 設定
        self.view.backgroundColor = cBackGround

        //******** UI Create
        self.createUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createUI() {
        
        //ラベルを生成
        let titleLabel = UILabel(frame: CGRect(x:0, y:self.view.frame.height/4, width:self.view.frame.width, height:30))
        titleLabel.textAlignment = .center
        titleLabel.text = "無料会員登録"
        self.view.addSubview(titleLabel)
    }

    
}

