//
//  ViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

protocol MonthlyCalendarViewControllerDelegate
{
    func showData()
}

class LoginViewController: UIViewController {

    var delegate: MonthlyCalendarViewControllerDelegate?
    var mailAddressText: TextFieldLeftPadding = TextFieldLeftPadding()
    var passwordText: UITextField = UITextField()

    var termsLabel: UILabel = UILabel()
    let linkText = "利用規約"
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//
//        //テストデータを作成
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        for index in 1...32 {
//            print("index is \(index)")
//
//            let newRef = ref!
//                .child("messages/groupID2")
//                .childByAutoId()
//
//            let newId = "messageID_\(newRef.key)"
//
//            //登録
//            let currentData = [
//                "created": Date().iso8601 ,
//                "message": "message その\(index)",
//                "sender": "MtOfUWmJuiUB4V6yCNO08i98cII3"
//                ] as [String : Any]
//
////            ref.child("messages/groupID2/\(newId)").setValue(currentData)
//            ref.child("messages/groupID2").childByAutoId().setValue(currentData)
//
//        }
        

        

        //******** Delegate
        self.delegate = MonthlyCalendarView

        //******** ログイン済みかを確認
        self.checkLogin()
        
        //******** 背景色 設定
        self.view.backgroundColor = cBackGround

        //******** UI Create
        self.createUI()

        //******** Indicator Create
        createIndicator(selfVC: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createUI() {
        
        //******** ラベルを生成
        let titleLabel = UILabel(frame: CGRect(x:0, y:self.view.frame.height/5, width:self.view.frame.width, height:30))
        titleLabel.textAlignment = .center
        titleLabel.text = "ログイン"
        titleLabel.font = titleLabel.font.withSize(25)
        self.view.addSubview(titleLabel)
        
        //********「メールアドレス」テキスト
        mailAddressText =  TextFieldLeftPadding(frame: CGRect(x: 0, y: self.view.frame.height/3 , width: self.view.frame.width, height: 60))
        mailAddressText.placeholder = "メールアドレス"
        mailAddressText.font = UIFont.systemFont(ofSize: 15)
//        mailAddressText.borderStyle = UITextBorderStyle.roundedRect
        mailAddressText.backgroundColor = UIColor.white

        mailAddressText.autocorrectionType = UITextAutocorrectionType.no
        mailAddressText.keyboardType = UIKeyboardType.default
        mailAddressText.returnKeyType = UIReturnKeyType.done
        mailAddressText.clearButtonMode = UITextFieldViewMode.whileEditing;
        mailAddressText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        mailAddressText.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.mailAddressText.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        self.view.addSubview(mailAddressText)

        //******** 「パスワード」テキスト
        passwordText =  UITextField(frame: CGRect(x: 10, y: self.view.frame.height/3 + 70 , width: self.view.frame.width - 20, height: 60))
        passwordText.placeholder = "パスワード"
        passwordText.font = UIFont.systemFont(ofSize: 15)
        passwordText.borderStyle = UITextBorderStyle.roundedRect
        passwordText.autocorrectionType = UITextAutocorrectionType.no
        passwordText.keyboardType = UIKeyboardType.default
        passwordText.returnKeyType = UIReturnKeyType.done
        passwordText.clearButtonMode = UITextFieldViewMode.whileEditing;
        passwordText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        passwordText.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.passwordText.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        self.view.addSubview(passwordText)

        //********「サインアップ」ボタン
        let signUpButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 140,width: self.view.frame.width - 20, height:60))
        signUpButton.setTitle("サインアップ", for: .normal)
        signUpButton.backgroundColor = cBlue
        signUpButton.layer.cornerRadius = 10
        signUpButton.rx.tap
            .subscribe { [weak self] _ in
                //サインアップ画面へ遷移
                self?.present(SignUpView, animated: true, completion: {
                    () -> Void in
                    print("HavingItem追加へ遷移後")
                })
            }
            .disposed(by: disposeBag)

        view.addSubview(signUpButton)

        //********「ログイン」ボタン
        let loginButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 70,width: self.view.frame.width - 20,height:60))
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.backgroundColor = cRed
        loginButton.layer.cornerRadius = 10
        loginButton.rx.tap
            .subscribe { [weak self] _ in
                //ログイン処理 実行
                self?.login()
            }
            .disposed(by: disposeBag)
        
        view.addSubview(loginButton)

    }
    
    func checkLogin() {
        let user = Auth.auth().currentUser
        if user != nil {
            //ログイン済 カレンダー画面へ遷移
            print("login")
            
            if let dg = self.delegate {
                dg.showData()
            } else {
                print("delegate 未設定")
            }
            
            self.navigationController?.pushViewController(MonthlyCalendarView, animated: true)

            
//            // The user's ID, unique to the Firebase project.
//            // Do NOT use this value to authenticate with your backend server,
//            // if you have one. Use getTokenWithCompletion:completion: instead.
//            let uid = user.uid
//            let email = user.email
//            let photoURL = user.photoURL
//            // ...
        }
    }
    
    //ログインボタン タップ時
    func login() {
        
        if (mailAddressText.text != "" && passwordText.text != "") {
            Auth.auth().signIn(withEmail: mailAddressText.text!, password: passwordText.text!) { (user, error) in
                // ...
                print("signIn")

                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    self.navigationController?.pushViewController(MonthlyCalendarView, animated: true)

//                    //Go to the HomeViewController if the login is sucessful
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    print("login error")

                    //Tells the user that there is an error and then gets firebase to tell them the error
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//
//                    self.present(alertController, animated: true, completion: nil)
                }
                
                
                
//                let user = Auth.auth().currentUser
//                if let user = user {
//                    // The user's ID, unique to the Firebase project.
//                    // Do NOT use this value to authenticate with your backend server,
//                    // if you have one. Use getTokenWithCompletion:completion: instead.
//                    let uid = user.uid
//                    let email = user.email
//                    let photoURL = user.photoURL
//                    // ...
//                }
            }
        }
    }
}

