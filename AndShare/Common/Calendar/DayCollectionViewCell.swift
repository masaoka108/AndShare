//
//  DayCollectionViewCell.swift
//  AndShare
//
//  Created by USER on 2018/04/24.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    public var textLabel:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

//        //UILabelを生成
//        textLabel = UILabel()
//        textLabel.frame = CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)
//        textLabel.textAlignment = .center
//        self.contentView.addSubview(textLabel!)

        // UILabelを生成
//        textLabel = UILabel(frame: CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height))
        textLabel = UILabel(frame: CGRect(x:0,y:0,width:self.frame.width,height:20))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.backgroundColor = UIColor.white
  
        textLabel.numberOfLines = 0;
//        textLabel.sizeToFit()

        // Cellに追加
        self.addSubview(textLabel!)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//import UIKit
//
//class DayCollectionViewCell: UICollectionViewCell {
//
//    public var textLabel: UILabel!
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//
//        // UILabelを生成
//        textLabel = UILabel(frame: CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height))
//        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
//        textLabel.textAlignment = NSTextAlignment.center
//        // Cellに追加
//        self.addSubview(textLabel!)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
//
//}
