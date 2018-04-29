//
//  DateManager.swift
//  AndShare
//
//  Created by USER on 2018/04/24.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

//import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//データソースとなるstruct
struct Day {
    let no: String
    let date: String

    init(no: String, date: String) {
        self.no = no
        self.date = date
    }
}

class MonthlyCalendarModel: NSDate {

    var data:[Day] = []

    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = NSDate()

    let daysPerWeek: Int = 7
    var numberOfWeeks: Int!
    var numberOfItems: Int!

    override init(){
        super.init()
        _ = self.daysAcquisition()
        dateForCellAtIndexPath(numberOfItem: numberOfItems)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //指定した年月のセル数を取得
    func cellCount(startDate:Date) -> Int{

        //その月が何週間あるかを取得
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: startDate)
        
        let numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        
        return numberOfItems
    }

    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth() as Date)
        
        numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        return numberOfItems
    }
    
    //月の初日を取得
    func firstDateOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from:selectedDate as Date)
        components.day = 1
        let firstDateMonth = Calendar.current.date(from: components)!
        return firstDateMonth
    }
    
    // ⑴表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItem: Int) {
        var dataTemp:[Day] = []
        
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = Calendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth())
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay! - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = Calendar.current.date(byAdding: dateComponents as DateComponents, to: firstDateOfMonth() as Date)!
            // ④配列に追加
            currentMonthOfDates.append(date as NSDate)
            
            // RxSwift 用のデータを作成
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "d"
            dataTemp.append(Day(no:formatter.string(from: date as Date) ,date:"1/1"))
        }
        
        //RxSwift用のデータソースをセット
        self.data = dataTemp
    }
    
    // ⑵表記の変更
    func conversionDateFormat(indexPath: IndexPath) -> String {
        dateForCellAtIndexPath(numberOfItem: numberOfItems)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: currentMonthOfDates[indexPath.row] as Date)
    }
    
    //前月の表示
    func prevMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate() as NSDate

        _ = self.daysAcquisition()
        dateForCellAtIndexPath(numberOfItem: numberOfItems)

        return selectedDate as Date
    }
    
    //次月の表示
    func nextMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate() as NSDate

        _ = self.daysAcquisition()
        dateForCellAtIndexPath(numberOfItem: numberOfItems)

        return selectedDate as Date
    }    
}


extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return calendar.date(byAdding: dateComponents, to: self)!
    }

    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue        
        return calendar.date(byAdding: dateComponents, to: self)!
    }
}
