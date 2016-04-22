//
//  UILabelPlus.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

class UILabelAutoSize: UILabel {
    
    init(origin: CGPoint, cellHeight: CGFloat, textOnLabel text: String, fontSize: Int) {
        let length = text.characters.count
        super.init(frame: CGRect(origin: origin, size: CGSize(width: CGFloat(length * (fontSize + 2)), height: cellHeight)))
        self.text = text
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

