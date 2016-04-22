//
//  InfoTable.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

extension ResultRepresentViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    
    // DataSource 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let image = imageOfColorWithRGB(grey.s100.colorRGB, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.width, height: 10)))
        return UIImageView(image: image)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = InfoCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.width, height: 30)))
        cell.selectionStyle = .None
        let numerator = self.numerator == nil ? "B" : self.numerator
        let denominator = self.denominator == nil ? "R" : self.denominator
        switch indexPath.section {
        case 0:
            cell.initSampleCell(title: numerator! + "/" + denominator!, result: self.rbRatio!, needCeilling: false)
        case 1:
            cell.initSampleCell(title: "Concentration", result: self.calculationResult!, needCeilling: true)
        default:
            cell.initSampleCell(title: "Others", result: 0.00, needCeilling: false)

        }
        cell.backgroundColor = grey.s100.colorRGB
        return cell
    }
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    // Delegate
    
    
    
    func UIColorFrom(hex hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }

    
    
    
}
