//
//  CalendarViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/11.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Firebase
import EventKit
import Koyomi

class CalendarViewController: UIViewController, CalendarViewControllerDelegate {
    
    // EventStoreを初期化
    let eventStore = EKEventStore()


    // Delegate メソッド
    func showData() {
        print("showData")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //******** 背景色 設定
        self.view.backgroundColor = cBackGround
        
//        //******** カレンダーの一覧の取得
//        let calendars = eventStore.calendars(for: .event)

        //******** UI Create
        self.createUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createUI() {

        //******** カレンダー
        let frame = CGRect(x: 0, y : 70, width: self.view.frame.width, height: self.view.frame.height - 170)
        //eventData でマーク入れる日付を渡す。
        let koyomi = Koyomi(frame: frame, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25, eventData:"test")
        view.addSubview(koyomi)
//        koyomi.isHiddenOtherMonth = true
        koyomi.selectionMode = .single(style: .background)
//        koyomi.style = .red
        
        koyomi.dayPosition = .topCenter
        koyomi.weekBackgrondColor = cBackGround
        koyomi.weeks = ("日", "月", "火", "水", "木", "金", "土")
        
 //       koyomi.inset = UIEdgeInsets(top: 1, left: 0.5, bottom: 0.5, right: 0.5)
//        koyomi.selectedDayTextState = .change(.green)

        
        //******** 現在月
        let currentDateString = koyomi.currentDateString(withFormat: "yyyy年MM月")

        let titleLabel = UILabel(frame: CGRect(x:0, y:25, width:self.view.frame.width, height:50))
        titleLabel.textAlignment = .center
        titleLabel.text = currentDateString
        titleLabel.font = titleLabel.font.withSize(18)
        self.view.addSubview(titleLabel)

        
        
        //次の月へ
        koyomi.display(in: .next)
//        case 0:  return .previous
//        case 1:  return .current
//        default: return .next
        
        
    }
    
    

    
    
    //******** EventKit 関連
    // 許可状況を確認して、許可されていなかったら許可を得る
    func allowAuthorization() {
        if getAuthorization_status() {
            // 許可されている
            return
        } else {
            // 許可されていない
            eventStore.requestAccess(to: .event, completion: {
                (granted, error) in
                if granted {
                    return
                }
                else {
                    print("Not allowed")
                }
            })
            
        }
    }
    
    // 認証ステータスを確認する
    func getAuthorization_status() -> Bool {
        // 認証ステータスを取得
        let status = EKEventStore.authorizationStatus(for: .event)
        
        // ステータスを表示 許可されている場合のみtrueを返す
        switch status {
        case .notDetermined:
            print("NotDetermined")
            return false
            
        case .denied:
            print("Denied")
            return false
            
        case .authorized:
            print("Authorized")
            return true
            
        case .restricted:
            print("Restricted")
            return false
        }
    }
    
    // イベントの一覧を取得
    func listEvents() {
        // 検索条件を準備
        let startDate = NSDate()
        let endDate = NSDate()
        let defaultCalendar = eventStore.defaultCalendarForNewEvents    // ここではデフォルトのカレンダーを指定
        // 検索するためのクエリー的なものを用意
        let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [defaultCalendar!])
        // イベントを検索
        let events = eventStore.events(matching: predicate)
    }

    // イベント追加
    func addEvent() {
        // イベントの情報を準備
        let startDate = NSDate()
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let endDate = cal.date(byAdding: .hour, value: 2, to: startDate as Date, options: NSCalendar.Options())!
        let title = "カレンダーテストイベント"
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        // イベントを作成して情報をセット
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate as Date?
        event.endDate = endDate
        event.calendar = defaultCalendar
        // イベントの登録
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch let error {
            print(error)
        }
        
    }

    // イベント削除
    func deleteEvent(event: EKEvent) {
        do {
            try eventStore.remove(event, span: .thisEvent)
        } catch let error {
            print(error)
        }
    }


}



