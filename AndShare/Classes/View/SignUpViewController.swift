//
//  SignUpViewController.swift
//  AndShare
//
//  Created by USER on 2018/04/11.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var mailAddressText: UITextField = UITextField()
    var userNameText: UITextField = UITextField()
    var passwordText: UITextField = UITextField()
    var termsLabel: UILabel = UILabel()
    let linkText = "利用規約"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        titleLabel.text = "無料会員登録"
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
        
        //********「ユーザー名」テキスト
        userNameText =  UITextField(frame: CGRect(x: 10, y: self.view.frame.height/3 + 70 , width: self.view.frame.width - 20, height: 60))
        userNameText.placeholder = "ユーザー名"
        userNameText.font = UIFont.systemFont(ofSize: 15)
        userNameText.borderStyle = UITextBorderStyle.roundedRect
        userNameText.autocorrectionType = UITextAutocorrectionType.no
        userNameText.keyboardType = UIKeyboardType.default
        userNameText.returnKeyType = UIReturnKeyType.done
        userNameText.clearButtonMode = UITextFieldViewMode.whileEditing;
        userNameText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        userNameText.delegate = self
        self.view.addSubview(userNameText)
        
        //******** 「パスワード」テキスト
        passwordText =  UITextField(frame: CGRect(x: 10, y: self.view.frame.height/3 + 140 , width: self.view.frame.width - 20, height: 60))
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

        //ラベルの一部をリンク化するのは難しい。対象文字列の位置を検出してタップ位置と照合する必要がありコストが高く、実装してみたら位置がズレる。少し上でしか反応しない。。
        //******** 「利用規約」ラベル
        termsLabel =  UILabel(frame: CGRect(x: 25, y: self.view.frame.height/3 + 250 , width: self.view.frame.width - 50, height: 100))
        termsLabel.text = "利用規約をお読みいただき、同意される方のみ「次へ」ボタンを押して下さい。"

        termsLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        termsLabel.addGestureRecognizer(tapGestureRecognizer)

        //表示可能最大行数を指定
        termsLabel.numberOfLines = 0
        //contentsのサイズに合わせてobujectのサイズを変える
        termsLabel.sizeToFit()
        //単語の途中で改行されないようにする
        termsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // リンク化させる場所を青くさせる。
        let string = termsLabel.text!
        let range = (string as NSString).range(of: linkText)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
        termsLabel.attributedText = attributedString

        self.view.addSubview(termsLabel)

        
        //********「次へ」ボタン
        let nextButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 70,width: self.view.frame.width - 20,height:60))
        nextButton.setTitle("次へ", for: .normal)
        nextButton.backgroundColor = cRed
        nextButton.addTarget(self, action: #selector(SignUpViewController.goNext(_:)), for: .touchUpInside)
        nextButton.layer.cornerRadius = 10
        view.addSubview(nextButton)
        
        
        
        
        
    }
    
    //利用規約 タップ時
    @objc func tapGesture(gestureRecognizer: UITapGestureRecognizer) {
        print("test")
        guard let text = termsLabel.text else { return }
        let touchPoint = gestureRecognizer.location(in: termsLabel)
        let textStorage = NSTextStorage(attributedString: NSAttributedString(string: linkText))
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: termsLabel.frame.size)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        let toRange = (text as NSString).range(of: linkText)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: toRange, actualCharacterRange: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        if glyphRect.contains(touchPoint) {
            print("Tapped")
        }
    }

    
    //ログインボタン タップ時
    @objc func goNext(_ sender: UIButton) {
        print("goNext")
        
        if (mailAddressText.text != "" && passwordText.text != "") {
            
            //******** ユーザー登録
            Auth.auth().createUser(withEmail: mailAddressText.text!, password: passwordText.text!) { (user, error) in
                // ...
                print("create")
                if (error == nil) {
                    //**** 登録完了
                    
                    //** displayName をupdate
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userNameText.text
                    changeRequest?.commitChanges { (error) in
                        if (error == nil) {
                            //**** 登録完了（displayName）

                            //メイン画面へ遷移
                            
                            
                        } else {
                            
                            
                        }
                    }
                    
                } else {
                    //**** 登録エラー

                    
                }
                
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
    

}
