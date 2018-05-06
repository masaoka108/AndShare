//
//  MessageTableViewCell.swift
//  AndShare
//
//  Created by USER on 2018/04/24.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

//    var wrapView:UIView!
    var nameLabel:UILabel!
    var iconImage:UIImage!
    var iconImageView:UIImageView!
    var messageLabel:UILabel!
    var sendDateLable:UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenRect = UIScreen.main.bounds
        
//        wrapView = UIView()
//        wrapView.frame = CGRect(x:0 ,y:0, width: screenRect.width, height: 200)
////        wrapView.backgroundColor = UIColor.red
//        contentView.addSubview(wrapView)
        
        //******** 名前
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x:0 ,y:0, width:screenRect.width, height: 15)
        contentView.addSubview(nameLabel)
        
        //******** 画像
        let imageName = "PersonDefault.png"
        let image = UIImage(named: imageName)
        iconImageView = UIImageView(image: image!)
        iconImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        contentView.addSubview(iconImageView)
//        iconImageView.backgroundColor = UIColor.red
        
        //******** メッセージ
        messageLabel = PaddingLabel()
        messageLabel.frame = CGRect(x:0 ,y:30, width:screenRect.width, height: 15)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
//        messageLabel.backgroundColor = cBackGround
        messageLabel.layer.backgroundColor  = cBackGround.cgColor
        messageLabel.layer.cornerRadius = 10
        
        contentView.addSubview(messageLabel)


        //******** 送信日時
        sendDateLable = UILabel()
        sendDateLable.frame = CGRect(x:0 ,y:45, width:screenRect.width, height: 15)
        contentView.addSubview(sendDateLable)

        

        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: iconImageView, attribute:.top, relatedBy:.equal, toItem:contentView, attribute:.top , multiplier:1, constant:5).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute:.left, relatedBy:.equal, toItem:contentView, attribute:.left , multiplier:1, constant:5).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute:.width, relatedBy:.equal, toItem:nil, attribute:.notAnAttribute , multiplier:1, constant:40).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute:.height, relatedBy:.equal, toItem:iconImageView, attribute:.width , multiplier:1, constant:0).isActive = true

        
//        NSLayoutConstraint(item: iconImageView, attribute:.leftMargin, relatedBy:.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: iconImageView, attribute:.rightMargin, relatedBy:.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: iconImageView, attribute:.bottomMargin, relatedBy:.equal, toItem:nameLabel, attribute:.top, multiplier:1, constant:1).isActive = true

        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nameLabel, attribute:.top, relatedBy:.equal, toItem:contentView, attribute:.top , multiplier:1, constant:5).isActive = true
        NSLayoutConstraint(item: nameLabel, attribute:.left, relatedBy:.equal, toItem:contentView, attribute:.left , multiplier:1, constant:iconImageView.frame.width + 10).isActive = true

//        NSLayoutConstraint(item: nameLabel, attribute:.leftMargin, relatedBy:.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: nameLabel, attribute:.rightMargin, relatedBy:.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: nameLabel, attribute:.bottomMargin, relatedBy:.equal, toItem:sendDateLable, attribute:.top, multiplier:1, constant:1).isActive = true
        
//        sendDateLable.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: sendDateLable, attribute:.top, relatedBy:.equal, toItem:contentView, attribute:.top, multiplier:1, constant:nameLabel.frame.height + iconImageView.frame.height).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.leftMargin, relatedBy:.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.rightMargin, relatedBy:.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.bottomMargin, relatedBy:.equal, toItem:messageLabel, attribute:.top, multiplier:1, constant:1).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageLabel, attribute:.top, relatedBy:.equal, toItem:contentView, attribute:.top, multiplier:1, constant:nameLabel.frame.height + 15).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute:.leftMargin, relatedBy:.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:iconImageView.frame.width + 10).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute:.rightMargin, relatedBy:.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
        NSLayoutConstraint(item: messageLabel, attribute:.bottomMargin, relatedBy:.equal, toItem:contentView, attribute:.bottomMargin, multiplier:1, constant:0).isActive = true
        
//        NSLayoutConstraint(item: sendDateLable, attribute:.top, relatedBy:.equal, toItem:contentView, attribute:.top, multiplier:1, constant:200).isActive = true
        
        // これで一応可変にはなっている。
//        NSLayoutConstraint(item: nameLabel, attribute:.topMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.bottomMargin , multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: nameLabel, attribute:.leftMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: nameLabel, attribute:.rightMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: nameLabel, attribute:.bottomMargin, relatedBy:NSLayoutRelation.equal, toItem:messageLabel, attribute:.bottomMargin, multiplier:1, constant:2).isActive = true
//
//
//        NSLayoutConstraint(item: messageLabel, attribute:.topMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.topMargin, multiplier:1, constant:20).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute:.leftMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute:.rightMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: messageLabel, attribute:.bottomMargin, relatedBy:NSLayoutRelation.equal, toItem:sendDateLable, attribute:.bottomMargin, multiplier:1, constant:2).isActive = true
//
//        NSLayoutConstraint(item: sendDateLable, attribute:.topMargin, relatedBy:NSLayoutRelation.equal, toItem:messageLabel, attribute:.topMargin, multiplier:1, constant:20).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.leftMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.leftMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.rightMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.rightMargin, multiplier:1, constant:0).isActive = true
//        NSLayoutConstraint(item: sendDateLable, attribute:.bottomMargin, relatedBy:NSLayoutRelation.equal, toItem:contentView, attribute:.bottomMargin, multiplier:1, constant:2).isActive = true

        
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
