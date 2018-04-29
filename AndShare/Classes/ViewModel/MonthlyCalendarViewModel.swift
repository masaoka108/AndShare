//
//  MonthlyCalendarViewModel.swift
//  AndShare
//
//  Created by USER on 2018/04/28.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import RxSwift

class MonthlyCalendarViewModel {
    let monthlyCalendarModel = MonthlyCalendarModel()   //Model
    let data:Variable<[Day]> = Variable([]) //これがCollectionViewのデータソースなので購読可能な状態とする。
    internal var selectedDate: Variable<NSDate> = Variable(NSDate())

    init() {
        //CollectionViewのデータソース プリセット
        _ = monthlyCalendarModel.daysAcquisition()
        monthlyCalendarModel.dateForCellAtIndexPath(numberOfItem: monthlyCalendarModel.numberOfItems)
        self.data.value = monthlyCalendarModel.data
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
