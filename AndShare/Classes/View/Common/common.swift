//
//  common.swift
//  AndShare
//
//  Created by USER on 2018/04/25.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import Foundation

func createUITab(width:CGFloat, height:CGFloat) ->UITabBar {
    
    var myTabBar:TabBar!
    
    let width = width
    let height = height
    let tabBarHeight:CGFloat = 75
    
    /**   TabBarを設置   **/
    myTabBar = TabBar()
    myTabBar.frame = CGRect(x:0,y:height - tabBarHeight,width:width,height:tabBarHeight)
    //バーの色
    myTabBar.barTintColor = cBackGround
    //選択されていないボタンの色
    myTabBar.unselectedItemTintColor = UIColor.white
    //ボタンを押した時の色
    myTabBar.tintColor = cBlue
    
    //ボタンを生成
//    let mostRecent:UITabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
//    let downloads:UITabBarItem = UITabBarItem(tabBarSystemItem: .featured , tag: 2)

//    let calendar:UITabBarItem = UITabBarItem(title: "カレンダー", image: UIImage(named: "TabCalendarIcon"), tag: 1)
//    let calendar2:UITabBarItem = UITabBarItem(title: "カレンダー", image: UIImage(named: "TabCalendarIcon"), tag: 2)
//    let calendar3:UITabBarItem = UITabBarItem(title: "カレンダー", image: UIImage(named: "TabCalendarIcon"), tag: 3)
//    let calendar4:UITabBarItem = UITabBarItem(title: "カレンダー", image: UIImage(named: "TabCalendarIcon"), tag: 4)

    let button2 = UIButton(type: .custom)
    button2.setBackgroundImage(UIImage(named: "TabCalendarIcon") , for: .normal)   // TODO:画像の用意
    button2.sizeToFit()
    button2.center = CGPoint(x: myTabBar.bounds.size.width / 8, y: myTabBar.bounds.size.height / 2)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(button2)

    let button3 = UIButton(type: .custom)
    button3.setBackgroundImage(UIImage(named: "TabGroupIcon") , for: .normal)   // TODO:画像の用意
    button3.sizeToFit()
    button3.center = CGPoint(x: myTabBar.bounds.size.width / 3.5, y: myTabBar.bounds.size.height / 2)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(button3)

    
//    //マイカレンダー
//    let button = UIButton(type: .custom)
//    button.setBackgroundImage(UIImage(named: "HomeButton") , for: .normal)   // TODO:画像の用意
//    button.sizeToFit()
//    //    button.center = CGPoint(x: myTabBar.bounds.size.width / 2, y: myTabBar.bounds.size.height - (button.bounds.size.height/2))
//    button.center = CGPoint(x: myTabBar.bounds.size.width / 2, y: 10)
//    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
//    myTabBar.addSubview(button)

    
    //センターの大きなボタン
    let button = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "HomeButton") , for: .normal)   // TODO:画像の用意
    button.sizeToFit()
//    button.center = CGPoint(x: myTabBar.bounds.size.width / 2, y: myTabBar.bounds.size.height - (button.bounds.size.height/2))
    button.center = CGPoint(x: myTabBar.bounds.size.width / 2, y: 10)
    //        button.addTarget(self, action: Selector("tapBigCenter:"), for: .touchUpInside)
    myTabBar.addSubview(button)

    
//    //ボタンをタブバーに配置する
//    myTabBar.items = [calendar, calendar2, calendar3, calendar4]
    
    return myTabBar
}


class TabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 70
        return size
    }
    
}
