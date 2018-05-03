//
//  MonthlyCalendarViewModel.swift
//  AndShare
//
//  Created by USER on 2018/04/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift
//import Firebase

class MonthlyCalendarViewModel {

    // カレンダー
    let monthlyCalendarModel = MonthlyCalendarModel()   //Model
    let data:Variable<[Day]> = Variable([]) //これがCollectionViewのデータソースなので購読可能な状態とする。
    internal var selectedDate: Variable<NSDate> = Variable(NSDate())

//    // チャット
//    var messages: [DataSnapshot]! = []

    
    init() {
        //CollectionViewのデータソース プリセット
        _ = monthlyCalendarModel.daysAcquisition()
        monthlyCalendarModel.dateForCellAtIndexPath(numberOfItem: monthlyCalendarModel.numberOfItems)
        self.data.value = monthlyCalendarModel.data
        
        

//        // データが追加された場合の処理のテスト(Listener)
//        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.messages.append(snapshot)
//            //            //テーブルに列を追加(多分)
//            //            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
//        })
//
//
//        //データ取得(テスト)
//        ref.child("messages").child("groupID1").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//                print("test")
//              let value = snapshot.value as? NSDictionary
//
//            //下記でデータにアクセス可能。
//            //(value?["messageID1"] as? NSDictionary)?["message"]  as? String
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
    }

    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("messages").removeObserver(withHandle: _refHandle)
//        }
    }

    //前月の表示
    func prevMonth() {
        selectedDate.value = monthlyCalendarModel.prevMonth(date: selectedDate.value as Date) as NSDate
        self.data.value = monthlyCalendarModel.data
    }
    
    //次月の表示
    func nextMonth() {
        selectedDate.value = monthlyCalendarModel.nextMonth(date: selectedDate.value as Date) as NSDate
        self.data.value = monthlyCalendarModel.data
    }
}
