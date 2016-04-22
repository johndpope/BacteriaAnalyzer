//
//  DashedBoardView.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

class DashedBorderView: UIView {
    
    var border:CAShapeLayer!
    var warnLabel: UILabel?
    var textOnLabel: String {
        get {
            return "please set a value"
        }
        set(currentPixel) {
            warnLabel?.attributedText = NSAttributedString(string: "\(currentPixel)*\(currentPixel)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize((9))])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        warnLabel = UILabel(frame: CGRect(x: 10, y: 4, width: 100, height: 12))
        warnLabel?.textColor = UIColor.whiteColor()
        self.addSubview(warnLabel!)
        
        border = CAShapeLayer();
        
        border.strokeColor = UIColor.grayColor().CGColor;
        border.fillColor = nil;
        border.lineDashPattern = [4, 4];
        self.layer.addSublayer(border);
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).CGPath;
        border.frame = self.bounds;
    }
    
    func addDashedFrame(inView view: UIView)  {
        border = CAShapeLayer();
        
        border.strokeColor = UIColor.whiteColor().CGColor;
        border.fillColor = nil;
        border.lineDashPattern = [4, 4];
        view.layer.addSublayer(border);
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).CGPath;
        border.frame = self.bounds;
        
    }
    
    func addLabel(currentPixel currentPixel: CGFloat) {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.text = "Current Pixel: \(currentPixel) * \(currentPixel)"
    }
    
    
}