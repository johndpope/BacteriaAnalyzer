//
//  InfoTable.swift
//  样品分析
//
//  Created by 王俊硕 on 16/3/22.
//  Copyright © 2016年 王俊硕. All rights reserved.
//

import UIKit

extension SampleAnalsisViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    
    // DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let image = imageOfColorWithRGB(grey.s500.colorRGB, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.width, height: 10)))
        return UIImageView(image: image)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        print("configuring Cell")
        //        let cell = tableView.dequeueReusableCellWithIdentifier("cellA")
        self.selectedTableView = tableView

        
        let cell = InfoCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.width, height: 30)))
        
        let touchOnce = UITapGestureRecognizer(target: self, action: #selector(SampleAnalsisViewController.aCellTapped(_:)))
        cell.addGestureRecognizer(touchOnce)
        cell.indexPath = indexPath
//        var numerator: String {
//            get {
//                if selectedNumerator == nil {
//                    return "B"
//                } else {
//                switch selectedNumerator! {
//                    case 0: return "R"
//                    case 1: return "G"
//                    case 2: return "B"
//                    default: return "Others"
//                    }
//                }
//            }
//        }
//        var denominaotr: String {
//            get {
//                if selectedDenominator == nil {
//                    return "R"
//                } else {
//                    switch selectedDenominator! {
//                    case 0: return "R"
//                    case 1: return "G"
//                    case 2: return "B"
//                    default: return "Others"
//                    }
//                }
//            }
//        }
        var numeratorValue: CGFloat {
            get {
                switch numeratorString {
                    case "R": return CGFloat(dataToPass[0])
                    case "G": return CGFloat(dataToPass[1])
                    case "B": return CGFloat(dataToPass[2])
                    default: return 255
                    
                }
            }
        }
        var denominatorValue: CGFloat {
            get {
                switch denominaotrString {
                case "R": return CGFloat(dataToPass[0])
                case "G": return CGFloat(dataToPass[1])
                case "B": return CGFloat(dataToPass[2])
                default: return 255
                    
                }
            }
        }
        
        cell.selectionStyle = .None //
        switch indexPath.section {
        case 0:
            cell.initInfo(title: "R", result: CGFloat(dataToPass[0]), color: UIColorFrom(hex: 0xdd191d))
        case 1:
            cell.initInfo(title: "G", result: CGFloat(dataToPass[1]), color: UIColorFrom(hex: 0x0a8f08))
        case 2:
            cell.initInfo(title: "B", result: CGFloat(dataToPass[2]), color: UIColorFrom(hex: 0x039be5))
        case 3:
            cell.initSampleCell(title: numeratorString + "/" + denominaotrString, result: numeratorValue / denominatorValue, needCeilling: false, flag: true)
        default:
            cell.initInfo(title: "Others", result: 0.00, color: UIColor.redColor())
            
        }
        cell.backgroundColor = grey.s50.colorRGB
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    // Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("User selected the row at the indexpaht: \(indexPath.section)")
        if indexPath.section == 3 {
            return
        }
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! InfoCell
        // 因为一共也就两个值 所以才用了 先选的作为分子 后选的作为分母 的方法
        
            if selectedCell.selectedState == false && selectedRowIndex.count <= 1 {
                print("selected the cell---------")
                selectedCell.backgroundColor = grey.s300.colorRGB
                
                selectedCell.selectedState = true
                rowIndex+=1
                selectedRowIndex[indexPath.section] = rowIndex // 利用字典键值唯一的特性
                

            } else {
                
                if selectedCell.selectedState != false {
                    
                print("deselected-------")
                selectedCell.backgroundColor = grey.s50.colorRGB
                
                selectedCell.selectedState = false
                selectedRowIndex[indexPath.section] = nil
                rowIndex-=1
                } else {
                    print("Sorry, we've gotten enough accompanies")
                }
            }
            print("selectedRowIndex: \(selectedRowIndex)")

        
        
        
        
    }
    
    func UIColorFrom(hex hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
        
    }
    
    func infoCellTapHandle(cell: InfoCell, functionCode: Int, isLeft: Bool) {
        if functionCode == 1 {
            // select row
            print("deselected a old cell")
            cell.removeWarnLabel()
            cell.backgroundColor = grey.s50.colorRGB
        } else {
            // deselect row
            print("selected a row")
            cell.addWarnLabel(position: isLeft)
            cell.backgroundColor = grey.s300.colorRGB
        }
    }
    func aCellTapped(gesture: UITapGestureRecognizer) {
        
//        selectedNumerator = indexPath.section
        let touchPoint = gesture.locationInView(self.view)
        let tappedCell = gesture.view as! InfoCell
        let isLeft = touchPoint.x < UIScreen.mainScreen().bounds.width / 2 ? true : false
        let currentCell = tappedCell.indexPath?.section
        
        if currentCell == 3 {
            return
        }
        
        if isLeft {
            if selectedDenominator == currentCell {
                return // 新选的d跟以前的n一样的话就不可以选择了
                
            }
            
            if selectedNumerator != nil {
               
                if selectedNumerator == currentCell {
                    // deselected
                    infoCellTapHandle(tappedCell, functionCode: 1, isLeft: isLeft)
                    selectedNumerator = nil
                } else {
                    // select new cell
                    infoCellTapHandle(tappedCell, functionCode: 0, isLeft: isLeft)
                    // deselect old cell
                    let indexPath = NSIndexPath(forRow: 0, inSection: selectedNumerator!)
                    let oldRow = selectedTableView?.cellForRowAtIndexPath(indexPath) as! InfoCell
                    infoCellTapHandle(oldRow, functionCode: 1, isLeft: isLeft)
                    
                    selectedNumerator = currentCell

                }

            }   else {
                // select new cell
                selectedNumerator = currentCell
                infoCellTapHandle(tappedCell, functionCode: 0, isLeft: isLeft)
            }
        } else {
            if selectedNumerator == currentCell {
                return
            }
            if selectedDenominator != nil {
               
                if selectedDenominator == currentCell {
                    // deselected
                    infoCellTapHandle(tappedCell, functionCode: 1, isLeft: isLeft)
                    selectedDenominator = nil
                }
                else {
                    // select new cell
                    infoCellTapHandle(tappedCell, functionCode: 0, isLeft: isLeft)
                    // deselect old cell
                    let indexPath = NSIndexPath(forRow: 0, inSection: selectedDenominator!)
                    let oldRow = selectedTableView?.cellForRowAtIndexPath(indexPath) as! InfoCell
                    infoCellTapHandle(oldRow, functionCode: 1, isLeft: isLeft)
                    
                    selectedDenominator = currentCell

                }
            }
            else {
                // select new cell
                selectedDenominator = currentCell
                infoCellTapHandle(tappedCell, functionCode: 0, isLeft: isLeft)
            }
            
        }
        
        
        
        
        
        
//        var action = cellAction.doNothing
//        
//        let touchPoint = gesture.locationInView(self.view)
//        let cell = gesture.view as! InfoCell
//        let isLeft = touchPoint.x < UIScreen.mainScreen().bounds.width / 2 ? true : false
//        
//
//        if isLeft {
//            // taped on left
//            if cell.flagIsOnScrenn {
//                action = .deSelect
//            } else {
//                if numerator == nil {
//                    action = .select
//                    numerator = currentCell
//                } else {
//                    action = .doNothing
//                    numerator = nil
//                }
//            }
//        } else {
//            // taped on right
//            if cell.flagIsOnScrenn {
//                action = .deSelect
//                denominator = nil
//            } else {
//                if denominator == nil {
//                    action = .select
//                    denominator = currentCell
//                } else {
//                    action = .doNothing
//                }
//            }
//        }
//        switch action {
//        case .doNothing: break
//        case .deSelect:
//            cell.removeWarnLabel()
//            cell.backgroundColor = grey.s50.colorRGB
//        case .select: cell.addWarnLabel(position: isLeft)
//            cell.backgroundColor = grey.s300.colorRGB
//        }
//        
    }
//    enum cellAction {
//        case doNothing
//        case select
//        case deSelect
//    }

}
