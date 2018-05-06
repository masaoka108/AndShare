//
//  Common.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit


//********* ViewController
var RootView:LoginViewController?
let SignUpView:SignUpViewController = SignUpViewController()
let MonthlyCalendarView:MonthlyCalendarViewController = MonthlyCalendarViewController()



//********* Color
let cBackGround = UIColor(hue: 0, saturation: 0, brightness: 0.92, alpha: 1.0)
let cRed = UIColor(hue: 0, saturation: 0.73, brightness: 0.88, alpha: 1.0)
let cRed2 = UIColor(hue: 0.0111, saturation: 0.82, brightness: 0.89, alpha: 1.0)
let cBlue = UIColor(hue: 0.6056, saturation: 0.78, brightness: 0.86, alpha: 1.0)
let cWhiteTransparent = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.8)
let cBlackTransparent = UIColor(hue: 0, saturation: 1, brightness: 0, alpha: 0.8)


//******** Calendar
let titleHeaderHeight:CGFloat = 27.5
let titleHeaderLine:CGFloat = 2.5


//******** UILabel(Paddingを設定できる)
class PaddingLabel: UILabel {
    
    @IBInspectable var padding: UIEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    
    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
}
