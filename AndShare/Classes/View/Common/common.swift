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
import Firebase


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
    talkButton.rx.tap
        .subscribe { [weak selfVC] _ in
            //******** メッセージボタン クリック時
            
            //**** チャット UIView
//            let frameUIView = CGRect(x: 0, y : (selfVC?.view.frame.height)! / 3 * 1, width: (selfVC?.view.frame.width)!, height: (selfVC?.view.frame.height)! / 3 * 2)
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
            let tableHeight = chatUIView.frame.height - 20.0 - 50.0
            let frame = CGRect(x: 0, y : 20, width: (selfVC?.view.frame.width)!, height: tableHeight)
            messageTableView = UITableView(frame: frame)
            messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
            messageTableView.backgroundColor = UIColor.clear
            messageTableView.allowsSelection = false;
//            messageTableView.rowHeight = 100
            messageTableView.rx
                .setDelegate(selfVC as! UITableViewDelegate)
                .disposed(by: disposeBag)
            messageTableView.separatorStyle = .none
//            messageTableView.delegate = selfVC as? MonthlyCalendarViewController


            

            
//            commonViewMoel
//                .dataMessages
//                .bind(to: messageTableView!.rx.items(cellIdentifier: "MessageCell", cellType: MessageTableViewCell.self))
//                { (row, element, cell) in
//                    cell.nameLabel.text = element.sender
//                    cell.messageLabel.text = element.message
////                    cell.sendDateLable.text = element.created
//
////                    let imagesRef = storageRef.child("images")
//                    Storage.storage().reference(forURL: "gs://andshare-fead4.appspot.com/main@2x.png").getData(maxSize: INT64_MAX) {(data, error) in
//                        if let error = error {
//                            print("Error downloading: \(error)")
//                            return
//                        }
//                        DispatchQueue.main.async {
//
//
////                            //これで一応表示はされる。
////                            let image = UIImage(data: data!)
////                            let imageView = UIImageView(image: image!)
////                            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
////                            cell.addSubview(imageView)
//
//
//
////                            cell.addSubview(<#T##view: UIView##UIView#>)
////                            cell.imageView = UIImageView(image: image!)
//
//                            cell.iconImageView?.image = UIImage.init(data: data!)
////                            cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//
//
//                            //cell.setNeedsLayout()
//                        }
//                    }
//
//
//                    cell.backgroundColor = UIColor.clear
////                    // 算出された幅と高さをセット
////                    let rect: CGSize = cell.messageLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
////                    cell.messageLabel.backgroundColor = UIColor.red
////                    cell.messageLabel.frame = CGRect(x: 0, y: 10, width: rect.width, height: rect.height)
//
//                }
//                .disposed(by: disposeBag)

            //RxSwiftを使ったTableViewへのデータバインド
            commonViewMoel.dataMessageRx
                .bind(to: messageTableView!.rx.items(cellIdentifier: "MessageCell", cellType: MessageTableViewCell.self))
                { (row, element, cell) in
                    cell.nameLabel.text = element.sender
                    cell.messageLabel.text = element.message

                    Storage.storage().reference(forURL: "gs://andshare-fead4.appspot.com/main@2x.png").getData(maxSize: INT64_MAX) {(data, error) in
                        if let error = error {
                            print("Error downloading: \(error)")
                            return
                        }
                        DispatchQueue.main.async {
                            cell.iconImageView?.image = UIImage.init(data: data!)
                        }
                    }
                    cell.backgroundColor = UIColor.clear
                }
                .disposed(by: disposeBag)

            
            
            //DBに変更があった場合 リアルタイムにここが実行される
//            let subscription = commonViewMoel.dataMessages
//                .subscribe(onNext: { message in
//                    print("string")
//                    messageTableView.reloadData()
//                    messageTableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
//
//                    ActivityIndicator.stopAnimating()
//                })

            //DBに変更があった場合 リアルタイムにここが実行される。(基本、上と同じだがこっちはBehaviorRelyを使用)
            commonViewMoel.dataMessageRx.asDriver()
                .drive(onNext: { message in
//                    print(message)
                    if (message.count > 0) {
                        messageTableView.reloadData()
                        
                        //1ページしか表示していない場合は始めの表示なので一番下までスクロールする
                        if (message.count == 10) {
                            //スクロールさせる
                            messageTableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        }
                    }
                    ActivityIndicator.stopAnimating()
                })
                .disposed(by: disposeBag)
            
            
            
            messageTableView.estimatedRowHeight = 100
            messageTableView.rowHeight = UITableViewAutomaticDimension
            chatUIView.addSubview(messageTableView!)

            //上までスクロールしたら過去データをロード
            //      contentOffset を監視する。
            messageTableView
                .rx.contentOffset
                .asObservable()
                .map {
                    //$0.y ・・・　現在表示しているロケーション
                    $0.y < 30
                }
                .distinctUntilChanged()
                .bind(to:commonViewMoel.scrollEndComing)
                .disposed(by:disposeBag)

            
            
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

            //******** Indicator 表示
            ActivityIndicator.startAnimatingOnTop(selfVC: selfVC!)
            
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

//private func shouldRequestNextPage() -> Bool {
//    return messageTableView.contentSize.height > 0 &&
//        messageTableView.
//}

//******** Indicator(ローディングのクルクル)
var ActivityIndicator: UIActivityIndicatorView!

func createIndicator(selfVC:UIViewController) {
    // ActivityIndicatorを作成＆中央に配置
    ActivityIndicator = UIActivityIndicatorView()
    ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    ActivityIndicator.center = selfVC.view.center
    
    // クルクルをストップした時に非表示する
    ActivityIndicator.hidesWhenStopped = true
    
    // 色を設定
    ActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    
    ActivityIndicator.tag = 900
    
    //Viewに追加
    selfVC.view.addSubview(ActivityIndicator)
}

extension UIActivityIndicatorView {
    func startAnimatingOnTop(selfVC:UIViewController) {
        for v in (selfVC.view.subviews) {
            if let v = v as? UIActivityIndicatorView, v.tag == 900  {
                // Indicator をTOPに持ってくる
                selfVC.view.bringSubview(toFront: v)
            }
        }

        ActivityIndicator.startAnimating()
    }
}



class TabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 70
        return size
    }
    
}
