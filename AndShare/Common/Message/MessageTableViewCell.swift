//
//  MessageTableViewCell.swift
//  AndShare
//
//  Created by USER on 2018/04/24.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var nameLabel:UILabel!
    var iconImage:UIImage!
    var messageLabel:UILabel!
    var sendDateLable:UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x:0 ,y:0, width: 200, height: 15)
        contentView.addSubview(nameLabel)

//        iconImage = UIImage()
//        iconImage.frame = CGRect(x:0 ,y:0, width: 200, height: 20)
//        contentView.addSubview(iconImage)

        messageLabel = UILabel()
        messageLabel.frame = CGRect(x:0 ,y:15, width: 200, height: 15)
        contentView.addSubview(messageLabel)

        sendDateLable = UILabel()
        sendDateLable.frame = CGRect(x:0 ,y:30, width: 200, height: 15)
        contentView.addSubview(sendDateLable)

        
    }
    
////    public var textLabel:UILabel!
////    public var lineUIView:UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame11)
//
////        // UILabelを生成
////        textLabel = UILabel(frame: CGRect(x:0,y:0,width:self.frame.width,height:titleHeaderHeight))
////        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
////        textLabel.textAlignment = NSTextAlignment.center
////        textLabel.backgroundColor = UIColor.white
////        textLabel.numberOfLines = 0;
////        self.addSubview(textLabel!)
////
////        //線 描画
////        lineUIView = UIView(frame: CGRect(x:0,y:titleHeaderHeight,width:self.frame.width + 2,height:titleHeaderLine))
////        lineUIView.backgroundColor = cRed2
////        lineUIView.isHidden = true
////        self.addSubview(lineUIView)
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
