//
//  CommonViewModel.swift
//  AndShare
//
//  Created by USER on 2018/05/03.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift
import RxCocoa
import Firebase

class CommonViewModel {

    let messageModel = MessageModel()   //Model
//    var comments: Observable<[String]>

//    var messages: [DataSnapshot]! = []
//    let dataMessages:Variable<[Message]> = Variable([]) //これがチャットのデータソースなので購読可能な状態とする。
    var dataMessages:Observable<[Message]> //これがチャットのデータソースなので購読可能な状態とする。
    internal let scrollEndComing = Variable(false)
    fileprivate let disposeBag = DisposeBag()
    var dataMessageRx:RxCocoa.BehaviorRelay<[Message]>
    
    init() {
        dataMessages = messageModel.messages().observeOn(MainScheduler.instance)

        dataMessageRx = messageModel.messagesRx()
        
        //スクロール時
        // subscribe はイベントの購読を行う（＝ここで受信する）
        scrollEndComing
            .asObservable()
            .subscribe(onNext: { bool in

                if (bool) {
                    print("TOPに達しました")
                    
//                     //データソースでいま何件表示しているかを確認して現ページを判定
                    var page:Int = self.dataMessageRx.value.count / 10
                    self.messageModel.currentPage = page + 1   //ページを加算

                    if (self.messageModel.dataMessageRx.value.count > 0) {
                        self.messageModel.data = []   //データ取得前に初期化
                        self.messageModel.messagesGet()
                    }
                }
                
//                if self.viewState.value.fetchEnabled() && bool {
//                    // Modelへアクセス
//                    self.eventModel.fetchEventList( self.nextEventsCount() )
//                }
            })
            .disposed(by:disposeBag)

    }

    //使用していない。
//    func getMessage() {
////        messages.value =
////        comments = commonModel.comments(for: "aaa")
////            .observeOn(MainScheduler.instance)
//
//        //self.dataMessages.value = commonModel.getMessage()
////        let data = commonModel.getMessage()
////        self.dataMessages.value = data
//
//
//    }

}
