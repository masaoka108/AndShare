//
//  common.swift
//  AndShare
//
//  Created by USER on 2018/04/25.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa


private let disposeBag = DisposeBag()
var inputText = UITextField()
var messageTableView: UITableView!
let commonViewMoel = CommonViewModel()


func createUITab(width:CGFloat, height:CGFloat, selfVC:UIViewController) ->UITabBar {
    
    var myTabBar:TabBar!
    
    let width = width
    let height = height
    let tabBarHeight:CGFloat = 75
    
    /**   TabBarを設置   **/
    myTabBar = TabBar()
    myTabBar.frame = CGRect(x:0,y:height - tabBarHeight,width:width,height:tabBarHeight)
    //バーの色
    myTabBar.barTintColor = cBackGround
    //選択されていないボタンの色
    myTabBar.unselectedItemTintColor = UIColor.white
    //ボタンを押した時の色
    myTabBar.tintColor = cBlue
    
    let calendarButton = UIButton(type: .custom)
    calendarButton.setBackgroundImage(UIImage(named: "TabCalendarIcon") , for: .normal)   // @ToDo:画像の用意
    calendarButton.sizeToFit()
    calendarButton.center = CGPoint(x: myTabBar.bounds.size.width / 8, y: myTabBar.bounds.size.height / 3)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(calendarButton)

    let groupButton = UIButton(type: .custom)
    groupButton.setBackgroundImage(UIImage(named: "TabGroupIcon") , for: .normal)   // @ToDo:画像の用意
    groupButton.sizeToFit()
    groupButton.center = CGPoint(x: myTabBar.bounds.size.width / 3.5, y: myTabBar.bounds.size.height / 3)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(groupButton)

    let talkButton = UIButton(type: .custom)
    talkButton.setBackgroundImage(UIImage(named: "TabTalkIcon") , for: .normal)   // @ToDo:画像の用意
    talkButton.sizeToFit()
    talkButton.center = CGPoint(x: myTabBar.bounds.size.width / 1.4, y: myTabBar.bounds.size.height / 3)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    talkButton.rx.tap
        .subscribe { [weak selfVC] _ in
            
            //**** チャット UIView
            let frameUIView = CGRect(x: 0, y : (selfVC?.view.frame.height)! / 3 * 1, width: (selfVC?.view.frame.width)!, height: (selfVC?.view.frame.height)! / 3 * 2)
            let chatUIView = UIView(frame: frameUIView)
            chatUIView.tag = 1000
            chatUIView.backgroundColor = cWhiteTransparent

            //**上部の閉じるbar
            let frameUIViewBar = CGRect(x:0, y:0, width: (selfVC?.view.frame.width)!, height: 20)
            let chatBarButton = UIButton(frame: frameUIViewBar)
            chatBarButton.backgroundColor = cBackGround
            chatBarButton.setTitle("▼", for: .normal)
            chatBarButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            chatBarButton.rx.tap
                .subscribe { [weak selfVC] _ in
                    for v in (selfVC?.view.subviews)! {
                        if let v = v as? UIView, v.tag == 1000  {
                            // そのオブジェクトを親のviewから取り除く
                            v.removeFromSuperview()
                        }
                    }
                }
                .disposed(by: disposeBag)

            chatUIView.addSubview(chatBarButton)

            //**チャット自体
            //TableView
            let frame = CGRect(x: 0, y : 20, width: (selfVC?.view.frame.width)!, height: (selfVC?.view.frame.height)! - 170)
            messageTableView = UITableView(frame: frame)
            messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
            chatUIView.addSubview(messageTableView!)
            
            commonViewMoel
                .dataMessages
                .bind(to: messageTableView!.rx.items(cellIdentifier: "MessageCell", cellType: MessageTableViewCell.self))
                { (row, element, cell) in
                    cell.nameLabel.text = element.sender
                    cell.messageLabel.text = element.message
                    cell.sendDateLable.text = element.created
                }
                .disposed(by: disposeBag)

            
            
            //DBに変更があった場合 リアルタイムにここが実行される
            let subscription = commonViewMoel.dataMessages
                .subscribe(onNext: { message in
                    print("string")
                    messageTableView.reloadData()
                })
            
            
            //**入力部分
            let frameUIViewInput = CGRect(x: 0, y : chatUIView.frame.height - 50, width: (selfVC?.view.frame.width)!, height: 50)
            let inputUIView = UIView(frame: frameUIViewInput)
            inputUIView.backgroundColor = cBackGround
            chatUIView.addSubview(inputUIView)

            //テキスト
            inputText = UITextField(frame: CGRect(x: 10, y: 5 , width: (selfVC?.view.frame.width)! - 70, height: 40))
            inputText.placeholder = "メッセージを入力"
            inputText.font = UIFont.systemFont(ofSize: 12)
            inputText.borderStyle = UITextBorderStyle.roundedRect
            inputText.autocorrectionType = UITextAutocorrectionType.no
            inputText.keyboardType = UIKeyboardType.default
            inputText.returnKeyType = UIReturnKeyType.done
            inputText.clearButtonMode = UITextFieldViewMode.whileEditing;
            inputText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            inputText.tag = 1001
            inputText.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
                .subscribe({ [weak selfVC] _ in
                    print("keyboard off")

                    for v in (selfVC?.view.subviews)! {
                        if let v = v as? UITextField, v.tag == 1001  {
                            // そのオブジェクトを親のviewから取り除く
                            v.resignFirstResponder()
                        }
                    }
                })
                .disposed(by: disposeBag)
            
            inputUIView.addSubview(inputText)
            selfVC?.view.addSubview(chatUIView)
        }
        .disposed(by: disposeBag)

    myTabBar.addSubview(talkButton)

    let inviteButton = UIButton(type: .custom)
    inviteButton.setBackgroundImage(UIImage(named: "TabInviteIcon") , for: .normal)   // @ToDo:画像の用意
    inviteButton.sizeToFit()
    inviteButton.center = CGPoint(x: myTabBar.bounds.size.width / 1.15, y: myTabBar.bounds.size.height / 3)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(inviteButton)
    
    //センターの大きなボタン
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "HomeButton") , for: .normal)   // TODO:画像の用意
    button.sizeToFit()
    button.center = CGPoint(x: myTabBar.bounds.size.width / 2, y: 10)
    myTabBar.addSubview(button)
    
    return myTabBar
}

class TabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 70
        return size
    }
    
}
