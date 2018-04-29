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
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

//class MonthlyCalendarViewController: UIViewController, MonthlyCalendarViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
class MonthlyCalendarViewController: UIViewController, MonthlyCalendarViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    fileprivate let viewModel = MonthlyCalendarViewModel()
    fileprivate let disposeBag = DisposeBag()

    var andShareCalendarUIView:UIView?
    var andShareCalendarBottomLineUIView:UIView?
    var andShareCalendarTopLineUIView:UIView?
    var andShareCalendar:UICollectionView?
    var menuTabBar:TabBar!


    // Evevartoreを初期化
    let eventStore = EKEventStore()


    // Delegate メソッド
    func showData() {
        print("showData")
    }


    //カレンダー関係
//    let dateManager = MonthlyCalendarModel()
//    let dateManager = viewModel.data.value
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 0.5
    var today: NSDate!
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    
    let headerPrevBtn:UIButton = UIButton()
    let headerNextBtn:UIButton = UIButton()

    var headerTitle:UILabel = UILabel()
    var calendarType:UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //******** 背景色 設定
        self.view.backgroundColor = cBackGround
        
//        //******** カレンダーの一覧の取得
//        let calendars = eventStore.calendars(for: .event)

        //******** UI Create
        self.createUI()
        
        
        //******** swipe
        view.rx
            .anyGesture(.swipe([.right]))
            .when(.recognized)
            .subscribe(onNext: {gesture in
                self.didSwipe(mode:"right")
            })
            .disposed(by: disposeBag)

        view.rx
            .anyGesture(.swipe([.left]))
            .when(.recognized)
            .subscribe(onNext: { gesture in
                self.didSwipe(mode:"left")
            })
            .disposed(by: disposeBag)

//        let frame = CGRect(x: 0, y : 0, width: 50, height: 100)
        
//        let request: NSFetchRequest<NSFetchRequestResult> = andShareCalendar!.rx
     


        //カレンダー(UICollectionView)にデータをバインド
        viewModel
            .data
            .asObservable()
            .bind(to: andShareCalendar!.rx.items(cellIdentifier: "DayCell", cellType: DayCollectionViewCell.self))
            { (row, element, cell) in

                //テキストカラー
                if (row % 7 == 0) {
                    cell.textLabel.textColor = UIColor.lightRed()
                } else if (row % 7 == 6) {
                    cell.textLabel.textColor = UIColor.lightBlue()
                } else {
                    cell.textLabel.textColor = UIColor.black
                }
                
                //テキスト配置
//                if indexPath.section == 0 {
//                    cell.textLabel.text = weekArray[row]
//                    cell.textLabel.backgroundColor = cBackGround
//
//                    //線 描画
//                    cell.lineUIView.isHidden = false
//
//                } else {
                    cell.textLabel.text = element.no
//                    cell.textLabel.text = self.viewModel.monthlyCalendarData2.value[row].no
                    cell.textLabel.backgroundColor = UIColor.white
                    cell.backgroundColor = UIColor.white
                    
                    //線 描画
                    cell.lineUIView.isHidden = true
                
                    //これで罫線書ける？？
                    //cell.layer.borderColor
//                }


            }
            .disposed(by: disposeBag)


        
//        viewModel
//        .monthlyCalendarData.asObservable()
//            .bind(to: andShareCalendar!.rx.items(cellIdentifier: "DayCell", cellType: DayCollectionViewCell.self))
//            { (row, element, cell) in
//                print("aa")
//                self.didSwipe(mode: "left")
//                cell.value?.text = "\(element) @ \(row)"
//            }
//            .disposed(by: disposeBag)


        andShareCalendar?.rx.setDelegate(self)
            .disposed(by:disposeBag)

        //******** modelの選択月が変わるとココを実行
        viewModel
            .selectedDate
            .asObservable()
            .subscribe(onNext: { selectedDate in //2 selectedDate のValueが変わるとココが呼ばれる
                self.andShareCalendar?.reloadData()
            })
            .disposed(by:disposeBag)


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
        //**** 曜日
        var i:CGFloat = 0
        weekArray.forEach { dayName in
            calendarType = UILabel(frame: CGRect(x: (self.view.frame.width / 7) * i,y: 85,width: self.view.frame.width / 7,height:40))
            calendarType.font = UIFont.systemFont(ofSize: 12)
            calendarType.text = dayName
            calendarType.textAlignment = NSTextAlignment.center
            view.addSubview(calendarType)
            
            i = i + 1
        }

        //**** 上のライン
        let lineTopFrame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: titleHeaderLine)
        andShareCalendarTopLineUIView = UIView(frame: lineTopFrame)
        andShareCalendarTopLineUIView?.backgroundColor = cRed2
        view.addSubview(andShareCalendarTopLineUIView!)

        //**** カレンダーを入れるUIView
        let frameUIView = CGRect(x: 0, y : 120 + titleHeaderLine, width: self.view.frame.width, height: self.view.frame.height)
        andShareCalendarUIView = UIView(frame: frameUIView)
        view.addSubview(andShareCalendarUIView!)

        //**** カレンダー自体
        let frame = CGRect(x: 0, y : 0, width: self.view.frame.width, height: self.view.frame.height - 170)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        andShareCalendar = UICollectionView(frame: frame, collectionViewLayout: layout)
        andShareCalendar?.backgroundColor = cBackGround
        andShareCalendar?.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "DayCell")
        andShareCalendarUIView?.addSubview(andShareCalendar!)

        //**** 下のライン
        let lineBottomFrame = CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: titleHeaderLine)
        andShareCalendarBottomLineUIView = UIView(frame: lineBottomFrame)
        andShareCalendarBottomLineUIView?.backgroundColor = cRed2
        view.addSubview(andShareCalendarBottomLineUIView!)

        //******** カレンダータイプ ラベル(グループ・個人)
        calendarType = UILabel(frame: CGRect(x: 0,y: 25,width: self.view.frame.width,height:40))
        calendarType.font = UIFont.systemFont(ofSize: 12)
        calendarType.text = "あなたのカレンダー"
        calendarType.textAlignment = NSTextAlignment.center
        view.addSubview(calendarType)
        
        //******** 表示月ラベル
        headerTitle = UILabel(frame: CGRect(x: 0,y: 50,width: self.view.frame.width,height:40))
        headerTitle.font = UIFont.systemFont(ofSize: 22)
        headerTitle.text = changeHeaderTitle(date: viewModel.selectedDate.value)
        headerTitle.textAlignment = NSTextAlignment.center
        view.addSubview(headerTitle)

        //******** Tabメニュー
        menuTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height) as! TabBar
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
        
    }
    


    

    
    
    //headerの月を変更
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.string(from: date as Date)
        return selectMonth
    }
  
    //******** swipe
    func didSwipe(mode:String) {

        if mode == "right" {
            print("Right")

            //前月へ
            viewModel.prevMonth()
            headerTitle.text = changeHeaderTitle(date: viewModel.selectedDate.value)    //@ToDo ここは値をバインドするべき

            //andShareCalendar の移動
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
        else if mode == "left" {
            print("Left")
            //次月へ
            viewModel.nextMonth()
            headerTitle.text = changeHeaderTitle(date: viewModel.selectedDate.value)    //@ToDo ここは値をバインドするべき

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

    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    


//    //******** EventKit 関連
//    // 許可状況を確認して、許可されていなかったら許可を得る
//    func allowAuthorization() {
//        if getAuthorization_status() {
//            // 許可されている
//            return
//        } else {
//            // 許可されていない
//            eventStore.requestAccess(to: .event, completion: {
//                (granted, error) in
//                if granted {
//                    return
//                }
//                else {
//                    print("Not allowed")
//                }
//            })
//
//        }
//    }
//
//    // 認証ステータスを確認する
//    func getAuthorization_status() -> Bool {
//        // 認証ステータスを取得
//        let status = EKEventStore.authorizationStatus(for: .event)
//
//        // ステータスを表示 許可されている場合のみtrueを返す
//        switch status {
//        case .notDetermined:
//            print("NotDetermined")
//            return false
//
//        case .denied:
//            print("Denied")
//            return false
//
//        case .authorized:
//            print("Authorized")
//            return true
//
//        case .restricted:
//            print("Restricted")
//            return false
//        }
//    }
//
//    // イベントの一覧を取得
//    func listEvents() {
//        // 検索条件を準備
//        let startDate = NSDate()
//        let endDate = NSDate()
//        let defaultCalendar = eventStore.defaultCalendarForNewEvents    // ここではデフォルトのカレンダーを指定
//        // 検索するためのクエリー的なものを用意
//        let predicate = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: [defaultCalendar!])
//        // イベントを検索
//        let events = eventStore.events(matching: predicate)
//    }
//
//    // イベント追加
//    func addEvent() {
//        // イベントの情報を準備
//        let startDate = NSDate()
//        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
//        let endDate = cal.date(byAdding: .hour, value: 2, to: startDate as Date, options: NSCalendar.Options())!
//        let title = "カレンダーテストイベント"
//        let defaultCalendar = eventStore.defaultCalendarForNewEvents
//        // イベントを作成して情報をセット
//        let event = EKEvent(eventStore: eventStore)
//        event.title = title
//        event.startDate = startDate as Date?
//        event.endDate = endDate
//        event.calendar = defaultCalendar
//        // イベントの登録
//        do {
//            try eventStore.save(event, span: .thisEvent)
//        } catch let error {
//            print(error)
//        }
//
//    }
//
//    // イベント削除
//    func deleteEvent(event: EKEvent) {
//        do {
//            try eventStore.remove(event, span: .thisEvent)
//        } catch let error {
//            print(error)
//        }
//    }


}


// UICollectionView の delegateを集めた
extension MonthlyCalendarViewController {
    
//    //1 secton数を指定
//    @objc func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//
//    //データの個数を設定
//    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        if section == 0 {
//            return 7
//        } else {
//            //            return dateManager.daysAcquisition()
//            return viewModel.monthlyCalendarData.value[0].daysAcquisition()
//        }
//    }
//
//    //データバインド
//    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let DayCell:DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath as IndexPath) as! DayCollectionViewCell
//
//        //テキストカラー
//        if (indexPath.row % 7 == 0) {
//            DayCell.textLabel.textColor = UIColor.lightRed()
//        } else if (indexPath.row % 7 == 6) {
//            DayCell.textLabel.textColor = UIColor.lightBlue()
//        } else {
//            DayCell.textLabel.textColor = UIColor.black
//        }
//        //テキスト配置
//        if indexPath.section == 0 {
//            DayCell.textLabel.text = weekArray[indexPath.row]
//            DayCell.textLabel.backgroundColor = cBackGround
//
//            //線 描画
//            DayCell.lineUIView.isHidden = false
//
//        } else {
////            DayCell.textLabel.text = dateManager.conversionDateFormat(indexPath: indexPath)
//            DayCell.textLabel.text = viewModel.monthlyCalendarData.value[0].conversionDateFormat(indexPath: indexPath)
//            DayCell.textLabel.backgroundColor = UIColor.white
//            DayCell.backgroundColor = UIColor.white
//
//            //線 描画
//            DayCell.lineUIView.isHidden = true
//        }
//
//        return DayCell
//    }
    
    
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
        
        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        //        var height:CGFloat = (self.view.frame.height - 170 - 30) / CGFloat(dateManager.numberOfWeeks)
        let height:CGFloat = (self.view.frame.height - 170 - 30) / CGFloat(viewModel.monthlyCalendarModel.numberOfWeeks)
        
        
        
        //        if indexPath.section == 0 {
        //            width = ((collectionView.frame.size.width - 0 * numberOfMargin) / CGFloat(daysPerWeek)) - 1
        //            height = titleHeaderHeight + titleHeaderLine
        //        }
        
        return CGSize(width:width,height:height)
    }
    
    
    //タップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
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


