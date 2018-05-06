//
//  MyAlertController.swift
//  AndShare
//
//  Created by USER on 2018/05/06.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ActionSheetController: UIViewController {
    
//    public var customView: UIView?
//    public var customViewMarginBottom: CGFloat = 16
    
    var menuUIView:UIView!
    let rx_message = PublishSubject<String>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let rect = CGRect(x: 0, y: self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height / 2)
        menuUIView = UIView(frame: rect)
        menuUIView.backgroundColor = UIColor.white
        
        let inviteButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55))
        inviteButton.setTitle("招待", for: .normal)
        inviteButton.contentHorizontalAlignment = .left
        inviteButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        inviteButton.setTitleColor(UIColor.black, for: .normal)
//        inviteButton.backgroundColor = UIColor.red
        inviteButton.rx.tap
            .subscribe { [weak self] _ in
                self?.rx_message.on(.next("invite"))
        }
        .disposed(by: disposeBag)


        menuUIView.addSubview(inviteButton)


        let memberListButton = UIButton(frame: CGRect(x: 0, y:55, width: self.view.frame.width, height: 55))
        memberListButton.setTitle("メンバー一覧", for: .normal)
        memberListButton.contentHorizontalAlignment = .left
        memberListButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        memberListButton.setTitleColor(UIColor.black, for: .normal)
//        memberListButton.backgroundColor = UIColor.blue
        menuUIView.addSubview(memberListButton)
        
        self.view.addSubview(menuUIView)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.didSelect()
        print("touchesBegan")
        rx_message.on(.next("close"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        guard let customView = self.customView else {
//            return
//        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0
        }
    }
}
