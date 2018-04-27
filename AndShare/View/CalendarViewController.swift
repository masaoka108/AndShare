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

class CalendarViewController: UIViewController, CalendarViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var andShareCalendarUIView:UIView?
    var andShareCalendarBottomLineUIView:UIView?
    var andShareCalendar:UICollectionView?
    var menuTabBar:TabBar!

    
    // EventStoreを初期化
    let eventStore = EKEventStore()


    // Delegate メソッド
    func showData() {
        print("showData")
    }


    //カレンダー関係
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
//    let cellMargin: CGFloat = 2.0
    let cellMargin: CGFloat = 0.5
    var selectedDate = NSDate()
    var today: NSDate!
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    
    let headerPrevBtn:UIButton = UIButton()
    let headerNextBtn:UIButton = UIButton()

    var headerTitle:UILabel = UILabel()
    var calendarType:UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //******** 背景色 設定
        self.view.backgroundColor = cBackGround
        
//        //******** カレンダーの一覧の取得
//        let calendars = eventStore.calendars(for: .event)

        //******** UI Create
        self.createUI()
        
        
        //******** swipe
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector(("didSwipe:")))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
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
        //**** カレンダーを入れるUIView
//        let frameUIView = CGRect(x: 0, y : 90, width: self.view.frame.width, height: self.view.frame.height - 170 + titleHeaderLine)
        let frameUIView = CGRect(x: 0, y : 90, width: self.view.frame.width, height: self.view.frame.height)
        andShareCalendarUIView = UIView(frame: frameUIView)
        view.addSubview(andShareCalendarUIView!)

        //**** カレンダー自体
        let frame = CGRect(x: 0, y : 0, width: self.view.frame.width, height: self.view.frame.height - 170)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: self.view.frame.width / 7 , height: (self.view.frame.height - 170) / 5)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 1
        andShareCalendar = UICollectionView(frame: frame, collectionViewLayout: layout)

        andShareCalendar?.dataSource = self
        andShareCalendar?.delegate = self
        andShareCalendar?.backgroundColor = cBackGround
        andShareCalendar?.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")

        //これでドラッグを有効にする事ができる
//        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDrag(_:)))//******** drag
//        andShareCalendar?.addGestureRecognizer(dragGesture)

        andShareCalendarUIView?.addSubview(andShareCalendar!)

        //**** 下のライン
//        let lineBottomFrame = CGRect(x: 0, y : self.view.frame.height - 80 + titleHeaderLine, width: self.view.frame.width, height: titleHeaderLine)
        let lineBottomFrame = CGRect(x: 0, y: self.view.frame.height - 170, width: self.view.frame.width, height: titleHeaderLine)
        andShareCalendarBottomLineUIView = UIView(frame: lineBottomFrame)
        andShareCalendarBottomLineUIView?.backgroundColor = cRed2
        andShareCalendarUIView?.addSubview(andShareCalendarBottomLineUIView!)


        
        //******** カレンダータイプ(グループ・個人)
        calendarType = UILabel(frame: CGRect(x: 0,y: 25,width: self.view.frame.width,height:40))
        calendarType.font = UIFont.systemFont(ofSize: 12)
        calendarType.text = "あなたのカレンダー"
        calendarType.textAlignment = NSTextAlignment.center
        view.addSubview(calendarType)
        
        //******** 表示月ラベル
        headerTitle = UILabel(frame: CGRect(x: 0,y: 50,width: self.view.frame.width,height:40))
        headerTitle.font = UIFont.systemFont(ofSize: 22)
        headerTitle.text = changeHeaderTitle(date: selectedDate)
        headerTitle.textAlignment = NSTextAlignment.center
        view.addSubview(headerTitle)

        //******** Tabメニュー
        menuTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height) as! TabBar
//        menuTabBar.delegate = self
        self.view.addSubview(menuTabBar)

        
//        //******** 前月、次月 ボタン
//        headerPrevBtn.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
//        headerPrevBtn.setTitle("前月", for: .normal)
//        headerPrevBtn.backgroundColor = cRed
//        headerPrevBtn.addTarget(self, action: #selector(self.PrevMonth(_:)), for: .touchUpInside)
//        headerPrevBtn.layer.cornerRadius = 10
//        view.addSubview(headerPrevBtn)
//
//        headerNextBtn.frame = CGRect(x: self.view.frame.width - 100, y: 40, width: 100, height: 20)
//        headerNextBtn.setTitle("次月", for: .normal)
//        headerNextBtn.backgroundColor = cRed
//        headerNextBtn.addTarget(self, action: #selector(self.NextMonth(_:)), for: .touchUpInside)
//        headerNextBtn.layer.cornerRadius = 10
//        view.addSubview(headerNextBtn)

        
        
        // ライブラリを使った場合の実装
//        //******** カレンダー
//        let frame = CGRect(x: 0, y : 70, width: self.view.frame.width, height: self.view.frame.height - 170)
//        //eventData でマーク入れる日付を渡す。
////        let koyomi = Koyomi(frame: frame, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25, eventData:"test")
//        let koyomi = Koyomi(frame: frame, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
//
//        view.addSubview(koyomi)
////        koyomi.isHiddenOtherMonth = true
//        koyomi.selectionMode = .single(style: .background)
////        koyomi.style = .red
//
//        koyomi.dayPosition = .topCenter
//        koyomi.weekBackgrondColor = cBackGround
//        koyomi.weeks = ("日", "月", "火", "水", "木", "金", "土")
//
// //       koyomi.inset = UIEdgeInsets(top: 1, left: 0.5, bottom: 0.5, right: 0.5)
////        koyomi.selectedDayTextState = .change(.green)

        
//        //******** 現在月
//        let currentDateString = koyomi.currentDateString(withFormat: "yyyy年MM月")
//
//        let titleLabel = UILabel(frame: CGRect(x:0, y:25, width:self.view.frame.width, height:50))
//        titleLabel.textAlignment = .center
//        titleLabel.text = currentDateString
//        titleLabel.font = titleLabel.font.withSize(18)
//        self.view.addSubview(titleLabel)
//
//
//
//        //次の月へ
//        koyomi.display(in: .next)
////        case 0:  return .previous
////        case 1:  return .current
////        default: return .next
        
        
    }
    

    //1 secton数を指定
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //データの個数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition()
        }
    }
    
    //タップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }

    //データバインド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let DayCell:DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath as IndexPath) as! DayCollectionViewCell
        //let DayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCollectionViewCell
        //テキストカラー
        
//        DayCell.backgroundColor = UIColor.lightGray
        
//        //セルのラベルに番号を設定する。
//        DayCell.titleLabel.text = String(indexPath.row + 1)
        

        //テキストカラー
        if (indexPath.row % 7 == 0) {
            DayCell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            DayCell.textLabel.textColor = UIColor.lightBlue()
        } else {
            DayCell.textLabel.textColor = UIColor.black
        }
        //テキスト配置
        if indexPath.section == 0 {
            DayCell.textLabel.text = weekArray[indexPath.row]
            DayCell.textLabel.backgroundColor = cBackGround
//            DayCell.backgroundColor = UIColor.clear
            
            //線 描画
            DayCell.lineUIView.isHidden = false
            
        } else {
            DayCell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath)
            DayCell.textLabel.backgroundColor = UIColor.white
            DayCell.backgroundColor = UIColor.white

            //線 描画
            DayCell.lineUIView.isHidden = true

            //月によって1日の場所は異なる(後ほど説明します)
        }
        
        return DayCell
    }
    
//    //セルの垂直方向のマージンを設定
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return cellMargin
//    }
//
//    //セルの水平方向のマージンを設定
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return cellMargin
//    }
    
    
    //let margin: CGFloat = 20.0

    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //レイアウト調整 行間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        return cellMargin
    }

    //レイアウト調整　列間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        return cellMargin
    }

    //セルのサイズを設定
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        let numberOfMargin:CGFloat = 8.0

        var width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        var height:CGFloat = (self.view.frame.height - 170 - 30) / CGFloat(dateManager.numberOfWeeks)

        if indexPath.section == 0 {
            width = ((collectionView.frame.size.width - 0 * numberOfMargin) / CGFloat(daysPerWeek)) - 1
            height = titleHeaderHeight + titleHeaderLine
        }

        return CGSize(width:width,height:height)
    }
    
    

    
    
    //ボタンアクション
    @objc func PrevMonth(_ sender: UIButton) {
        selectedDate = dateManager.prevMonth(date: selectedDate as Date) as NSDate
        andShareCalendar?.reloadData()
        headerTitle.text = changeHeaderTitle(date: selectedDate)
    }
    
    @objc func NextMonth(_ sender: UIButton) {
        selectedDate = dateManager.nextMonth(date: selectedDate as Date) as NSDate
        andShareCalendar?.reloadData()
        headerTitle.text = changeHeaderTitle(date: selectedDate)
    }
    
    
    
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.string(from: date as Date)
        return selectMonth
    }
  
    //******** swipe
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")

            
            //前月へ
            selectedDate = dateManager.prevMonth(date: selectedDate as Date) as NSDate
            andShareCalendar?.reloadData()
            headerTitle.text = changeHeaderTitle(date: selectedDate)

            
//            //andShareCalendar の移動
//            let returnMove = UIView.animate(withDuration: 0.5, delay: 0.0, options: .autoreverse, animations: {
//                self.andShareCalendarUIView?.center.x -= 100.0
//            }, completion: nil)

            
            //andShareCalendar の移動
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .autoreverse, animations: {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.andShareCalendarUIView?.center.x += 400.0
            }, completion: { finished in
                
                self.andShareCalendarUIView?.frame.origin.x -= 800.0

                // ①が終わったら、
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    self.andShareCalendarUIView?.center.x += 400.0
                }, completion:nil)

            })
            

            

        }
        else if sender.direction == .left {
            print("Left")
            //次月へ
            selectedDate = dateManager.nextMonth(date: selectedDate as Date) as NSDate
            andShareCalendar?.reloadData()
            headerTitle.text = changeHeaderTitle(date: selectedDate)

            //andShareCalendar の移動
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.andShareCalendarUIView?.center.x -= 400.0
            }, completion: { finished in
                
                self.andShareCalendarUIView?.frame.origin.x += 800.0
                
                // ①が終わったら、
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    self.andShareCalendarUIView?.center.x -= 400.0
                }, completion:nil)
                
            })


        }
    }
    
//    //******** ドラッグ時に呼ばれる
//    @objc func didDrag(_ sender: UISwipeGestureRecognizer) {
//        print("asdf")
//    }


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

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}


