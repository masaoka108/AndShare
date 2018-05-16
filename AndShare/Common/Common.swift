//
//  Common.swift
//  AndShare
//
//  Created by USER on 2018/04/10.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


//********* ViewController
//var RootView:LoginViewController?
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


//******** TextField 左のPaddingを設定
class TextFieldLeftPadding: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}



extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
