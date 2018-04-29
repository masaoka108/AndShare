//
//  MonthlyCalendarViewModel.swift
//  AndShare
//
//  Created by USER on 2018/04/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift

class MonthlyCalendarViewModel {

//    fileprivate let eventModel = EventsModel()
//    fileprivate let disposeBag = DisposeBag()
    
    //これがCollectionViewのデータソースなので購読可能な状態とする。(月の遷移時、この値が変わらない事が判明)
//    internal let monthlyCalendarData: Variable<MonthlyCalendarModel> =  Variable(MonthlyCalendarModel())
//    internal let monthlyCalendarData: Variable<[MonthlyCalendarModel]> =  Variable([MonthlyCalendarModel()])
//    let monthlyCalendarData2 = MonthlyCalendarModel().data

    let data:Variable<[Day]> = Variable([])
    let monthlyCalendarModel = MonthlyCalendarModel()

    //    internal let monthlyCalendarData = Observable.just(MonthlyCalendarModel())
    internal var selectedDate: Variable<NSDate> = Variable(NSDate())

//    var dataSource = MonthlyCalendarModel().dataSource

    init() {
//        monthlyCalendarData.value.append(MonthlyCalendarModel())
        _ = monthlyCalendarModel.daysAcquisition()
        monthlyCalendarModel.dateForCellAtIndexPath(numberOfItem: monthlyCalendarModel.numberOfItems)
        self.data.value = monthlyCalendarModel.data
    }
    
//    
//    init() {
//        
//        /**
//         APIの結果をsubscribeしている
//         */
//        // subscribe はイベントの購読を行う。（＝受信する側）
//        // ここでは requestState　を観察（observe）している。
//        eventModel
//            .requestState
//            .asObservable()
//            .observeOn(scheduler.main)
//            .subscribe(onNext: { requestState in
//                self.subscribeState(requestState)
//            })
//            .disposed(by:disposeBag)
//    }
//    
//    
//    
//    /**
//     ATND APIで、未取得のイベントを取ってくるために、これまでに取得したイベント数 + 1をを指定
//     */
//    func nextEventsCount() -> Int {
//        return self.events.value.count + 1
//    }
//    

    //前月の表示
    func prevMonth() {

        
        selectedDate.value = monthlyCalendarModel.prevMonth(date: selectedDate.value as Date) as NSDate
        self.data.value = monthlyCalendarModel.data
        
//        selectedDate.value = (selectedDate.value as Date).monthAgoDate() as NSDate

    }
    
    //次月の表示
    func nextMonth() {

        selectedDate.value = monthlyCalendarModel.nextMonth(date: selectedDate.value as Date) as NSDate
        self.data.value = monthlyCalendarModel.data

        //        selectedDate.value = monthlyCalendarData.value[0].nextMonth(date: selectedDate.value as Date) as NSDate
    }

}
