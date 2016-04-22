//
//  InfoCell.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    var titleLabel: UILabelAutoSize?
    var resultLabel: UILabelAutoSize?
    var flagLabel: UILabelAutoSize?
    var flagIsLeft: Bool? // 0 to Left, 1 to Right
    var flagIsOnScrenn: Bool = false
    
    var colorBar: UIView?
    var selectedState: Bool = false
    
    var indexPath: NSIndexPath? // 28 added
    
    func initInfo(title title: String, result: CGFloat, color: UIColor) {
        let width = UIScreen.mainScreen().bounds.width
        let height = CGFloat(44)
        
        
        let barWidth = 0.33 * width * result / 255
        let barOriginX = 0.333 * width
        let barOriginY = 0.433 * height - 2
        let barHeight = 0.15 * height
        
        let titleOriginX = 0.19 * width
        let titleOriginY = 0.25 * height
        let titleHeight = 1 / 2 * height
        
        let resultOriginX = 0.75 * width
        let resultOriginY = titleOriginY
        let resultHeight = titleHeight
        
        
        resultLabel = UILabelAutoSize(origin: CGPoint(x: resultOriginX, y: resultOriginY), cellHeight: resultHeight, textOnLabel: result.description, fontSize: 15)
        titleLabel = UILabelAutoSize(origin: CGPoint(x: titleOriginX, y: titleOriginY), cellHeight: titleHeight, textOnLabel: title, fontSize: 15)
        colorBar = UIView(frame: CGRect(origin: CGPoint(x: barOriginX, y: barOriginY), size: CGSize(width: barWidth, height: barHeight)))
        colorBar?.backgroundColor = color
        
        titleLabel?.font = UIFont(name: "Times", size: 15)
        resultLabel?.font = UIFont(name: "Times", size: 15)

        
        contentView.addSubview(resultLabel!)
        contentView.addSubview(titleLabel!)
        contentView.addSubview(colorBar!)
    }
    
    func initSampleCell(title title: String, result: CGFloat, needCeilling: Bool, flag: Bool = false) {
        let width = UIScreen.mainScreen().bounds.width
        let height = CGFloat(44)
       
        
        
        var titleOriginX = 0.19 * width
        let titleOriginY = 0.25 * height
        let titleHeight = 1 / 2 * height
        
        var resultOriginX = 0.56 * width
        let resultOriginY = titleOriginY
        let resultHeight = titleHeight
    
    
        var resultString = NSString(format: "%.3f", result) as String
        
        if flag == true {
            titleOriginX = 0.19 * width
            resultOriginX = 0.75 * width
        } else {
            var resultValue = result
            var digits = 0
            
            if resultValue / 1000 >= 1{
                while resultValue / 10 >= 1 {
                    resultValue = resultValue / 10
                    digits += 1
                }
                
                resultString = NSString(format: "%.3f", resultValue) as String
                resultString = resultString + "*10^" +  String(digits)
                resultString += " CFU/mL"

            } else {
                if needCeilling {
                    let range = resultString.endIndex.advancedBy(-2)..<resultString.endIndex
                    resultString.removeRange(range)
                    let lastChar = resultString[resultString.endIndex.advancedBy(-1)]
                    if lastChar < "5" {
                        let range = resultString.endIndex.advancedBy(-2)..<resultString.endIndex
                        resultString.removeRange(range)
                    } else {
                        let range = resultString.endIndex.advancedBy(-2)..<resultString.endIndex
                        resultString.removeRange(range)
                        resultString[resultString.endIndex.advancedBy(-3)]
                        var value = Int(resultString)
                        value! += 1
                        resultString = String(value!)
                    }
                    resultString += " CFU/mL"
                }
            }
            
        }
      
        
        resultLabel = UILabelAutoSize(origin: CGPoint(x: resultOriginX, y: resultOriginY), cellHeight: resultHeight, textOnLabel: resultString, fontSize: 15)

        titleLabel = UILabelAutoSize(origin: CGPoint(x: titleOriginX, y: titleOriginY), cellHeight: titleHeight, textOnLabel: title, fontSize: 15)
        titleLabel?.font = UIFont(name: "Times", size: 15)
        resultLabel?.font = UIFont(name: "Times", size: 15)

        
        
        
        contentView.addSubview(resultLabel!)
        contentView.addSubview(titleLabel!)

        
    }
    
    func addWarnLabel(position position: Bool) {
        flagIsOnScrenn = true
        
        let frame = self.frame
        let width = frame.width
        let height = frame.height
        
        
        
        let flagOriginX = position == true ? 0.06 * width : 0.9 * width
        let flagContent = position == true ? "N" : "D"
        let flagOriginY =  0.25 * height
        let flagHeight =  1 / 2 * height
        

        flagLabel = UILabelAutoSize(origin: CGPoint(x: flagOriginX, y: flagOriginY), cellHeight: flagHeight, textOnLabel: flagContent, fontSize: 9)
        
        contentView.addSubview(flagLabel!)
    }
    func removeWarnLabel() {
        flagIsOnScrenn = false
        flagLabel?.removeFromSuperview()
    }

}
