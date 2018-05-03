//
//  CommonViewModel.swift
//  AndShare
//
//  Created by USER on 2018/05/03.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift
import Firebase

class CommonViewModel {

    let messageModel = MessageModel()   //Model
//    var comments: Observable<[String]>

//    var messages: [DataSnapshot]! = []
//    let dataMessages:Variable<[Message]> = Variable([]) //これがチャットのデータソースなので購読可能な状態とする。
    var dataMessages:Observable<[Message]> //これがチャットのデータソースなので購読可能な状態とする。
    
    init() {

        dataMessages = messageModel.messages().observeOn(MainScheduler.instance)

    }
    
    func getMessage() {
//        messages.value =
//        comments = commonModel.comments(for: "aaa")
//            .observeOn(MainScheduler.instance)
        
        //self.dataMessages.value = commonModel.getMessage()
//        let data = commonModel.getMessage()
//        self.dataMessages.value = data


    }

}
