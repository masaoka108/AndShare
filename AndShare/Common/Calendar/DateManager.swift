//
//  DateManager.swift
//  AndShare
//
//  Created by USER on 2018/04/24.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class DateManager: NSDate {
    
//    var currentMonthOfDates = [NSDate]() //表記する月の配列
////    var selectedDate = Date()
//
//    //現在の日付
//    private var selectedDate = Date()
//
//    //１週間に何日あるか
//    private let daysPerWeek:Int = 7
//
//    //セルの個数(nilが入らないようにする)
//    private var numberOfItems:Int = 0

    var currentMonthOfDates = [NSDate]() //表記する月の配列
    var selectedDate = NSDate()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    
//    //指定した月から現在の月までのセルの数を返すメソッド
//    func cellCount(startDate:Date) -> Int{
//        let startDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:startDate)
//        let currentDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:selectedDate)
//        //作成月と現在の月が違う時はその分表示    components.monthではなれた月分
//        let components = NSCalendar.current.dateComponents([.year,.month], from: startDateComponents, to: currentDateComponents)
//        let numberOfMonth = components.month! + components.year! * 12
//
//        for i in 0 ..< numberOfMonth + 1{
//            let dateComponents = NSDateComponents()
//            dateComponents.month = i
//            let date = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: startDate)
//            //in(その月)にof(日)が何個あるか
//            let dateRange = NSCalendar.current.range(of: .weekOfMonth, in: .month, for: date!)
//            //月の初日が何曜日かを取得 日曜日==1
//            let ordinalityOfFirstDay = NSCalendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date:date!))
//            if(ordinalityOfFirstDay == 1 || i == 0){
//                numberOfItems = numberOfItems + dateRange!.count * daysPerWeek
//            }else{
//                numberOfItems = numberOfItems + (dateRange!.count - 1) * daysPerWeek
//            }
//        }
//        return numberOfItems
//    }

    //指定した年月のセル数を取得
    func cellCount(startDate:Date) -> Int{

        //その月が何週間あるかを取得
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: startDate)
        
        let numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek //週の数×列の数
        
//        //        let startDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:startDate)
//        let currentDateComponents = NSCalendar.current.dateComponents([.year ,.month], from:selectedDate)
//        //作成月と現在の月が違う時はその分表示    components.monthではなれた月分
//        let components = NSCalendar.current.dateComponents([.year,.month], from: startDateComponents, to: currentDateComponents)
//        let numberOfMonth = components.month! + components.year! * 12
//
//        for i in 0 ..< numberOfMonth + 1{
//            let dateComponents = NSDateComponents()
//            dateComponents.month = i
//            let date = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: startDate)
//            //in(その月)にof(日)が何個あるか
//            let dateRange = NSCalendar.current.range(of: .weekOfMonth, in: .month, for: date!)
//            //月の初日が何曜日かを取得 日曜日==1
//            let ordinalityOfFirstDay = NSCalendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date:date!))
//            if(ordinalityOfFirstDay == 1 || i == 0){
//                numberOfItems = numberOfItems + dateRange!.count * daysPerWeek
//            }else{
//                numberOfItems = numberOfItems + (dateRange!.count - 1) * daysPerWeek
//            }
//        }
        return numberOfItems
    }

    
    
//    //指定された月の初日を取得
//    func firstDateOfMonth(date:Date) -> Date{
//        var components = NSCalendar.current.dateComponents([.year ,.month, .day], from:date)
//        components.day = 1
//        let firstDateMonth = NSCalendar.current.date(from: components)
//        return firstDateMonth!
//    }
//
//
//    //表記する日にちの取得　週のカレンダー
//    func dateForCellAtIndexPathWeeks(row:Int,startDate:Date) -> Date{
//        //始まりの日が週の何番目かを計算(日曜日が１) 指定した月の初日から数える
//        let ordinalityOfFirstDay = NSCalendar.current.ordinality(of: .day, in: .weekOfMonth, for: firstDateOfMonth(date:startDate))
//        let dateComponents = NSDateComponents()
//        dateComponents.day = row - (ordinalityOfFirstDay! - 1)
//        //計算して、基準の日から何日マイナス、加算するか dateComponents.day = -2 とか
//        let date = NSCalendar.current.date(byAdding:dateComponents as DateComponents,to:firstDateOfMonth(date:startDate))
//        return date!
//    }
//
//    //表記の変更 これをセルを作成する時に呼び出す
//    func conversionDateFormat(row:Int,startDate:Date) -> String{
//        let cellDate = dateForCellAtIndexPathWeeks(row: row,startDate:startDate)
//        let formatter:DateFormatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter.string(from: cellDate)
//
//    }
//
//    //月日を返す
//    func monthTag(row:Int,startDate:Date) -> String{
//        let cellDate = dateForCellAtIndexPathWeeks(row: row,startDate:startDate)
//        let formatter:DateFormatter = DateFormatter()
//        formatter.dateFormat = "YM"
//        return formatter.string(from:cellDate)
//    }

    //月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = Calendar.current.range(of: .weekOfMonth, in: .month, for: firstDateOfMonth() as Date)
        
        let numberOfWeeks = Int((rangeOfWeeks?.count)!) //月が持つ週の数
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
        }
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
        return selectedDate as Date
    }
    
    //次月の表示
    func nextMonth(date: Date) -> Date {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate() as NSDate
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
