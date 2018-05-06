//
//  CalendarViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/11.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import EventKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import GoogleAPIClientForREST
import GoogleSignIn

//class MonthlyCalendarViewController: UIViewController, MonthlyCalendarViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
class MonthlyCalendarViewController: UIViewController, MonthlyCalendarViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate
{

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
    let daysPerWeek: Int = 7
//    let cellMargin: CGFloat = 0.5
    let cellMargin: CGFloat = 0
    var today: NSDate!
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    
    let headerPrevBtn:UIButton = UIButton()
    let headerNextBtn:UIButton = UIButton()

    var headerTitle:UILabel = UILabel()
    var calendarType:UILabel = UILabel()
    
    //Google Calendar関係
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //******** 背景色 設定
        self.view.backgroundColor = cBackGround
        
        //******** カレンダーAppのデータ取得
        allowAuthorization()

        let calendars = eventStore.calendars(for: .event)
        // 検索条件を準備
        var dateString = "2014-07-15" // change to your date format
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.date(from: dateString)

        var dateString2 = "2018-06-01" // change to your date format
        var dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        var date2 = dateFormatter2.date(from: dateString2)


//        let startDate = NSDate()
//        let endDate = NSDate()
        let startDate = date
        let endDate = date2

        let defaultCalendar = eventStore.defaultCalendarForNewEvents    // ここではデフォルトのカレンダーを指定
        // 検索するためのクエリー的なものを用意
//        let predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate! , calendars: [defaultCalendar!])
        let predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate! , calendars: [defaultCalendar!])
        // イベントを検索
        let events = eventStore.events(matching: predicate)
        // 下記でデータ取得可能
        // events[0].title | events[0].startDate | events[0].endDate | events[0].isAllDay | events[0].location
        


//        let eventStore = EKEventStore()
//        let calendars = eventStore.calendars(for: .event)
//
//        let today = Date()
//        let cal = Calendar.current
//        let midnightToday = cal.startOfDay(for: today)
//        let midnightTomorrow = midnightToday.addingTimeInterval(24*3600)
//        let midnightDayAfterTomorrow = midnightTomorrow.addingTimeInterval(24*3600)
//
//        for calendar in calendars {
//            if listOfCandidateCalendars.contains(calendar.title) {
//                var predicate: NSPredicate
//                if areEventsFromToday() {
//                    predicate = eventStore.predicateForEvents(withStart: midnightToday, end: midnightTomorrow, calendars: [calendar])
//                } else {
//                    predicate = eventStore.predicateForEvents(withStart: midnightTomorrow, end: midnightDayAfterTomorrow, calendars: [calendar])
//                }
//
//                let events = eventStore.events(matching: predicate)
//
//                for event in events {
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "HH:mm"
//                    let formattedString = formatter.string(from: event.startDate)
//                    eventList.append(formattedString + "\t  " + event.title)
//                }
//            }
//        }
        
        
        //******** UI Create
        self.createUI()
        
        //******** Indicator Create
        createIndicator(selfVC: self)
        
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

 
        //******** カレンダー(UICollectionView)にデータをバインド
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
                
                    //日付
                    cell.textLabel.text = element.no

                    //背景色
                    cell.textLabel.backgroundColor = UIColor.white
                    cell.backgroundColor = UIColor.white

                
                    //予定を表示
                    //一旦削除
                    let subviews = cell.subviews
                    for subview in subviews {
                        if (subview.tag == 1) {
                            subview.removeFromSuperview()
                        }
                    }
                
                    //@ToDo とりあえずモック
                    if (element.no == "7" || element.no == "11" || element.no == "22") {
                        let eventLabel = UILabel(frame: CGRect(x: 0, y: cell.textLabel.frame.height, width: cell.frame.width,height:17))
                        eventLabel.font = UIFont.systemFont(ofSize: 12)
                        eventLabel.textColor = UIColor.white
                        eventLabel.backgroundColor = cRed2
                        eventLabel.text = "グループ"
                        eventLabel.textAlignment = NSTextAlignment.center
                        eventLabel.tag = 1
                        cell.addSubview(eventLabel)
                    }

                    //線 描画
                    cell.lineUIView.isHidden = true
                
                    //これで罫線書ける？？
                    cell.layer.borderColor = cBackGround.cgColor
                    cell.layer.borderWidth = 0.4

//                }


            }
            .disposed(by: disposeBag)

        andShareCalendar?.rx.setDelegate(self)
            .disposed(by:disposeBag)

        
        //******** Google Calendar
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
        // Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        //view.addSubview(output); //ここはテストでイベントを文字列で書き出している
        
        //******** modelの選択月が変わるとココを実行
//        viewModel
//            .selectedDate
//            .asObservable()
//            .subscribe(onNext: { selectedDate in //2 selectedDate のValueが変わるとココが呼ばれる
//                self.andShareCalendar?.reloadData()
//            })
//            .disposed(by:disposeBag)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createUI() {

        //******** メニューアイコン
        let menuButton = UIButton(type: .custom)
        menuButton.setBackgroundImage(UIImage(named: "MenuIcon") , for: .normal)   // @ToDo:画像の用意
        menuButton.sizeToFit()
        menuButton.center = CGPoint(x: 30, y: 60)
        menuButton.rx.tap
            .subscribe { [weak self] _ in
                //******** メニューアイコン クリック時
        
            }
            .disposed(by: disposeBag)
        
        view.addSubview(menuButton)

        //******** ギアアイコン
        let gearButton = UIButton(type: .custom)
        gearButton.setBackgroundImage(UIImage(named: "GearIcon") , for: .normal)   // @ToDo:画像の用意
        gearButton.sizeToFit()
        gearButton.center = CGPoint(x: self.view.frame.width - 30, y: 60)
        gearButton.rx.tap
            .subscribe { [weak self] _ in
                //******** メニューアイコン クリック時

                
//                // styleをActionSheetに設定
//                let alertSheet = UIAlertController(title: "title", message: "message", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//                // 自分の選択肢を生成
//                let action1 = UIAlertAction(title: "1", style: UIAlertActionStyle.default, handler: {
//                    (action: UIAlertAction!) in
//                    print("1")
//                })
//                let action2 = UIAlertAction(title: "aka", style: UIAlertActionStyle.destructive, handler: {
//                    (action: UIAlertAction!) in
//                    print("aka")
//                })
//                let action_custom = UIAlertAction(title: "custom", style: UIAlertActionStyle.destructive, handler: {
//                    (action: UIAlertAction!) in
//                    print("aka")
//                })
//                let action3 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: {
//                    (action: UIAlertAction!) in
//                    print("cancel")
//                })
//
//                // アクションを追加.
//                alertSheet.addAction(action1)
//                alertSheet.addAction(action2)
//                alertSheet.addAction(action3)
//
//                self?.present(alertSheet, animated: true, completion: nil)
                
//                let view = UIView(frame: CGRect(x: 0, y: 0, width:(self?.view.frame.width)!, height: 300))
//                view.backgroundColor = .green
                
//                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//                label.backgroundColor = .orange
//                label.text = "custom view"
//                label.textColor = .white
//                label.textAlignment = .center
//                view.addSubview(label)
                
//                let alert = MyAlertController(
//                    title          : "ほげ",
//                    message        : "ふが",
//                    preferredStyle : .actionSheet
//                )
//                alert.addAction(UIAlertAction(
//                    title   : "へい",
//                    style   : .default,
//                    handler : nil
//                ))
//                alert.addAction(UIAlertAction(
//                    title   : "へい",
//                    style   : .destructive,
//                    handler : nil
//                ))
//                alert.addAction(UIAlertAction(
//                    title   : "へい",
//                    style   : .cancel,
//                    handler : nil
//                ))
//                alert.customView = view
//
//                print(alert.accessibilityFrame.width)
//                print(self?.view.frame.width)
                
                //******** Action Sheet風のメニュー表示
                let menu = ActionSheetController()

                //**** 背景を透かし黒にする。
                menu.modalPresentationStyle = .overCurrentContext
                menu.view.backgroundColor = cBlackTransparent
                menu.view.isOpaque = false

                //**** メニューを追加

                //**** メニューやそれ以外の部分をタップした時の動作
                menu.rx_message
                    .subscribe { [ weak menu]  message in
//                        print("Did select : \(message): \(sampleView!)")
                        print("Did select : \(message)")

                        if (message.element == "close") {
                            menu?.dismiss(animated: true, completion: nil)
                        } else {
                            print(message.element)
                        }
                    }
                    .disposed(by: (self?.disposeBag)!)

                
                
                //**** 表示
                self?.present(menu, animated: false, completion: nil)

                
            }
            .disposed(by: disposeBag)
        
        view.addSubview(gearButton)

        
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


        //******** Tabメニュー
        menuTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height, selfVC: self) as! TabBar
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


    
    //******** Google Calendar関係のDelegate
    //GoogleSignIn でこのsignファンクションが必須
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 100
//        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Display the start dates and event summaries in the UITextView
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var outputText = ""
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let startString = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)
                outputText += "\(startString) - \(event.summary!)\n"
            }
        } else {
            outputText = "No upcoming events found."
        }
        output.text = outputText
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //******** カレンダーApp関連
    let listOfCandidateCalendars: [String] = ["Home", "Classes"]
    
    var eventList: [String] = []
    
    func getTableSize() -> Int {
        return eventList.count
    }
    
    func getTitle(index: Int) -> String {
        return eventList[index]
    }
    
    func areEventsFromToday() -> Bool {
        let changeDateThreshold = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
        return Date() <= changeDateThreshold
    }
    
    
    
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
    
    //******** message TableViewのdelegate
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("aa")
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return MessageTableViewCell.self(frame: CGRect(x: 0, y : 20, width:100, height: 100))
//    }


    //これで行の高さ変えられる(RxSwift)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
        return UITableViewAutomaticDimension
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0),
//                              at: UITableViewScrollPosition.bottom, animated: true)
//    }

//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
}


extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}


