//
//  MessageModel.swift
//  AndShare
//
//  Created by USER on 2018/05/03.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift
import Firebase

//チャット データソースとなるstruct
struct Message {
    let sender: String
    let message: String
    let created: Int
    
    init(sender:String, message:String, created:Int) {
        self.sender = sender
        self.message = message
        self.created = created
    }
}


class MessageModel {
    private let ref = Database.database().reference()
    fileprivate var _refHandle: DatabaseHandle!
    
    
    func getMessage() -> [Message] {
        var data:[Message]? = []
        
        ref.child("messages").child("groupID1").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("test")

            let snapshotDict = snapshot.value as? NSDictionary
            for (key, value) in snapshotDict! {
                print("Property: \"\(key as! String)\"")
                
                let sender = (value as? NSDictionary)?["sender"] as? String
                let message = (value as? NSDictionary)?["message"] as? String
                let created = (value as? NSDictionary)?["created"] as? Int
                data?.append(Message(sender: sender!, message: message!, created: created!))
            }
            
            //下記でデータにアクセス可能。
            //(value?["messageID1"] as? NSDictionary)?["message"]  as? String

        }) { (error) in
            print(error.localizedDescription)
        }

        return data!
    }

    func messages() -> Observable<[Message]> {

//        // データが追加された場合の処理のテスト(Listener)
//        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            
//            print("aaaa")
//            //strongSelf.messages.append(snapshot)
//            //            //テーブルに列を追加(多分)
//            //            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
//        })

        
        return Observable.create { observer in

//            ref.child("messages").child("groupID1").observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user value
//                print("test")
//                let value = snapshot.value as? NSDictionary
//
//                //下記でデータにアクセス可能。
//                //(value?["messageID1"] as? NSDictionary)?["message"]  as? String
//
//            }) { (error) in
//                print(error.localizedDescription)
//            }

            
//            let commentsRef = self.ref.child("messages").child("groupID1")
//            let refHandle = commentsRef.observe(.value, with: { snapshot in
//                guard let commentsDict = snapshot.value as? [String: Any] else { return }
//                let comments = Array(commentsDict.keys)
//                observer.onNext(comments)
//            })
//
//            return Disposables.create {
//                commentsRef.removeObserver(withHandle: refHandle)
//            }

            //FirebaseのリアルタイムDBの状態を購読する
            let commentsRef = self.ref.child("messages").child("groupID2").queryOrdered(byChild: "created")
                //.queryEqual(toValue: true)
                //.queryOrdered(byChild: "created")
            let refHandle = commentsRef.observe(.value , with: { snapshot in

                for child in snapshot.children {
//                    print((child as AnyObject).key)
                    print("aaa")
                }
                
//            let refHandle = commentsRef.observe(.childAdded, with: { snapshot in
                guard let commentsDict = snapshot.value as? [String: Any] else { return }

                var data:[Message]? = []
                let snapshotDict = snapshot.value as? NSDictionary
                for (key, value) in snapshotDict! {
                    print("Property: \"\(key as! String)\"")
                    
                    let sender = (value as? NSDictionary)?["sender"] as? String
                    let message = (value as? NSDictionary)?["message"] as? String
                    let created = Int(((value as? NSDictionary)?["created"] as? String)!)
                    data?.append(Message(sender: sender!, message: message!, created: created!))
                }


//                let comments = Array(commentsDict.keys)
                
                //subscribeしている箇所を実行する
                observer.onNext(data!)
            })
            
            return Disposables.create {
                commentsRef.removeObserver(withHandle: refHandle)
            }

        }
    }
    
    func comment(_ comment: String, for username: String) {
        let comment = self.ref.child("users/\(username)/comments/\(comment)")
        comment.setValue(true)
    }
    
}
