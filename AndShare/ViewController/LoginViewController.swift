//
//  ViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Firebase

protocol CalendarViewControllerDelegate
{
    func showData()
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    var delegate: CalendarViewControllerDelegate?
    var mailAddressText: UITextField = UITextField()
    var passwordText: UITextField = UITextField()

    var termsLabel: UILabel = UILabel()
    let linkText = "利用規約"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //******** Delegate
        self.delegate = CalendarView
        //CalendarView.delegate = self

        //******** ログイン済みかを確認
        self.checkLogin()
        
        //******** 背景色 設定
        self.view.backgroundColor = cBackGround

        //******** UI Create
        self.createUI()
        
        
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
        mailAddressText =  UITextField(frame: CGRect(x: 10, y: self.view.frame.height/3 , width: self.view.frame.width - 20, height: 60))
        mailAddressText.placeholder = "メールアドレス"
        mailAddressText.font = UIFont.systemFont(ofSize: 15)
        mailAddressText.borderStyle = UITextBorderStyle.roundedRect
        mailAddressText.autocorrectionType = UITextAutocorrectionType.no
        mailAddressText.keyboardType = UIKeyboardType.default
        mailAddressText.returnKeyType = UIReturnKeyType.done
        mailAddressText.clearButtonMode = UITextFieldViewMode.whileEditing;
        mailAddressText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        mailAddressText.delegate = self
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
        passwordText.delegate = self
        self.view.addSubview(passwordText)

        //********「サインアップ」ボタン
        let signUpButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 140,width: self.view.frame.width - 20, height:60))
        signUpButton.setTitle("サインアップ", for: .normal)
        signUpButton.backgroundColor = cBlue
        signUpButton.addTarget(self, action: #selector(LoginViewController.signUp(_:)), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 10
        view.addSubview(signUpButton)

        //********「ログイン」ボタン
        let loginButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 70,width: self.view.frame.width - 20,height:60))
        loginButton.setTitle("ログイン", for: .normal)
        loginButton.backgroundColor = cRed
        loginButton.addTarget(self, action: #selector(LoginViewController.login(_:)), for: .touchUpInside)
        loginButton.layer.cornerRadius = 10
        view.addSubview(loginButton)

    }
    
    func checkLogin() {
        let user = Auth.auth().currentUser
        if let user = user {
            //ログイン済 カレンダー画面へ遷移
            print("login")
            
            if let dg = self.delegate {
                dg.showData()
            } else {
                print("delegate 未設定")
            }
            
            
            //self.delegate?.showList()
            //ReceiptListItemView.view.backgroundColor = cRed2
            self.navigationController?.pushViewController(CalendarView, animated: true)

            
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
    @objc func login(_ sender: UIButton) {
        
        if (mailAddressText.text != "" && passwordText.text != "") {
            Auth.auth().signIn(withEmail: mailAddressText.text!, password: passwordText.text!) { (user, error) in
                // ...
                print("signIn")

                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
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

        

        
//        guard let itemName = nameTextField?.text else {
//            fatalError("名前が入力されていません。")
//        }
//
//        //**** マスタに存在しているかAPIで確認
//        let escapedString:String = itemName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let ret = APIAccess(url: "\(apiHost)item/\(escapedString)")
//
//
//
//        if ((ret?.count)! == 0) {
//            let alert = msgAlert(title:"エラー", message:"登録されていない材料なので登録出来ません。")
//            present(alert, animated: true, completion: nil)
//            return
//        }
//
//        //**** HavingItem へインサート
//        Model.saveHavingItem(itemName:itemName);
//
//        //**** Alert表示
//        let alert: UIAlertController = UIAlertController(title: "完了メッセージ", message: "材料の登録が完了しました。", preferredStyle:  UIAlertControllerStyle.alert)
//        // OKボタン
//        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
//            // ボタンが押された時の処理を書く（クロージャ）
//            (action: UIAlertAction!) -> Void in
//            print("OK")
//
//            self.dismiss(animated: true, completion: {
//                () -> Void in
//                print("画面遷移後")
//
//                if let dg = self.delegate {
//                    dg.reloadScrollView()
//                } else {
//                    print("delegate 未設定")
//                }
//            })
//
//        })
//
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//
//
        
    }
    
    //サインアップ ボタン　タップ時
    @objc func signUp(_ sender: UIButton) {
        self.present(SignUpView, animated: true, completion: {
            () -> Void in
            print("HavingItem追加へ遷移後")
        })
    }
}

